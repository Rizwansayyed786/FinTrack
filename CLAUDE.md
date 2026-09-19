# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

FinTrack is a SwiftUI iOS app (personal-finance dashboard). Single Xcode target, no SPM/CocoaPods dependencies, no test target.

- Xcode project: `FinTrack.xcodeproj`, target/scheme `FinTrack`, bundle id `rizwan.FinTrack`
- Deployment target: iOS 26.5, Swift language mode 5, `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and `SWIFT_APPROACHABLE_CONCURRENCY = YES` (types are main-actor isolated by default — don't add `@MainActor` annotations that the setting already implies)
- Frameworks used: SwiftUI, Swift Charts, Foundation/URLSession

## Commands

Build and run on a simulator:

```bash
xcodebuild -project FinTrack.xcodeproj -scheme FinTrack \
  -destination 'platform=iOS Simulator,name=iPhone 17' build

xcrun simctl boot "iPhone 17"   # if not already booted
xcrun simctl install "iPhone 17" "<derived-data>/Build/Products/Debug-iphonesimulator/FinTrack.app"
xcrun simctl launch "iPhone 17" rizwan.FinTrack
```

Fast syntax/type check without a full build (currently passes clean):

```bash
xcrun --sdk iphonesimulator swiftc -typecheck \
  -target arm64-apple-ios26.5-simulator \
  -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  $(find FinTrack -name "*.swift")
```

There are no tests and no lint/format tooling configured.

## Architecture

Clean-architecture-per-feature. Each feature under `FinTrack/Features/<Feature>/` owns four layers, and dependencies only ever point inward (Presentation → Domain ← Data):

- `Domain/Entities` — plain structs the UI consumes (`User`, `Dashboard`, `Balance`, `Transaction`, `SpendingOverview`)
- `Domain/Repositories` — protocol the domain depends on (`AuthRepository`, `HomeRepository`)
- `Domain/Usecases` — one struct per action, single `execute(...)` method (`LoginUsecases`, `HomeUsecase`)
- `Data/Remote` — `*API` structs holding a `NetworkClient`; decode `APIResponseWrapper<DTO>`, unwrap `success`/`data`, return entities
- `Data/Models` — `*DTO`/`*Model` `Decodable` structs, each with a `toEntity()` extension. DTOs never leave the Data layer.
- `Data/Repositories` — `*RepoImpl` classes implementing the domain protocol over the API
- `Presentation` — `@Observable final class *ViewModel` holding a single mutable `state` struct (`LoginState`, `HomeState` with `isLoading` / `error` / payload); views take the view model via `init` into `@State private var viewModel` and bind with `$viewModel.state.field`

Wiring is manual constructor injection, no DI framework:

- `AppContainer` (`FinTrack/AppContainer.swift`) creates the one shared `NetworkClient` and exposes `makeRootView()` / `makeHomeView()` / `makeMainTabView()`. `FinTrackApp` roots the scene at `makeRootView()`.
- `<Feature>Factory` (e.g. `HomeFactory`, `AuthFactory`) assembles API → repo → use case → view model → view for that feature. **Add a factory per new feature and a `make…View()` on `AppContainer`; never construct a repository or API inside a view.**
- `MainTabView` (the 4-tab shell) lives in `FinTrack/Features/Home/Presentation/NavBar.swift`, not in a file named for it. Home, Settings (logout only) and Profile have content; Reports is still a placeholder `Text` view.

### Navigation: never push `MainTabView`

`RootView` (`Features/Auth/Presentation/RootView.swift`) **swaps** between `LoginView` and `MainTabView` on `session.isAuthenticated`. It must stay a swap, not a push.

`MainTabView` was previously pushed onto `LoginView`'s own `NavigationStack` via `navigationDestination(isPresented:)`. That made every tab's `NavigationStack` a nested stack living inside a pushed destination, and the symptom was that tapping a `NavigationLink(value:)` in the Profile tab **popped the whole tab shell and returned to the login screen** instead of pushing. If in-tab navigation starts bouncing to login, check this first — `LoginView` owns no `NavigationStack` and no `navigationDestination`, and it should stay that way.

### `NavigationManager`

`FinTrack/Core/Navigation/NavigationManager.swift` is `@Observable` and owns **one `NavigationPath` per tab** (`homePath`, `settingsPath`, `reportsPath`, `profilePath`) plus `selectedTab`.

- **One path per tab is load-bearing.** A single shared `NavigationPath` looks tidier but is wrong: every tab's `NavigationStack` reads the same value, so a push in Home also deepens Profile.
- It is injected through `@Environment`, not initialisers — `RootView` applies `.environment(container.navigation)` to the tab shell, and `MainTabView` / `SettingsView` read `@Environment(NavigationManager.self)`. Views needing bindings do `@Bindable var navigation = navigation` at the top of `body`. **Environment is for views only** — view models keep constructor injection, which is what keeps them testable.
- Routes stay feature-owned (`HomeRoute`, `ProfileRoute`) and the manager is generic over `Hashable`, so `Core` never imports a feature. Add a route enum next to its feature and register it with `navigationDestination(for:)` in that feature's root view — don't add cases to a global enum.
- API: `push(_:on:)`, `push(_:switchingTo:)` (cross-tab deep links), `pop(_:)`, `popToRoot(_:)`, `reset()`.
- The manager lives in `AppContainer` and **outlives the tab shell**, so `reset()` must be called on logout (`SettingsView` does) or the next sign-in resumes mid-navigation.

Shared code:

- `FinTrack/Core/Network/` — `NetworkClient` (thin async `URLSession` wrapper, throws `APIError.invalidResponse` / `.httpError`), `APIResponseWrapper<T>` (`success`/`message`/`data`), `APIError` (`.invalidResponse` / `.httpError(Int)` / `.server(String)`, the last carrying `message` from a `success: false` envelope)
- `FinTrack/DesignSystem/Theme/AppColors.swift` — `Color(hex:)` initializer plus the `Color.app*` palette. Prefer these tokens over inline `Color(hex: "…")`; much of `HomeView` still hardcodes hex/`.white`/`.black`.
- `FinTrack/DesignSystem/Components/` — cross-feature views (`AsyncImageComponent`, a circular `AsyncImage` with loading/failure phases). Put new reusable UI here, not in a feature folder.
- `FinTrack/Core/Storage/KeychainStore.swift` — generic-password Keychain wrapper (`save` / `read` / `delete` by account, `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`). Credentials go here, never in `UserDefaults`.

## Auth session

`AuthSession` (`FinTrack/AuthSession.swift`) is the **single source of truth for "is the user signed in"** — `@Observable`, holding a Keychain-backed token:

- `AppContainer` creates exactly one and injects it into `AuthFactory` and `MainTabView`. It reads the token from the Keychain in its `init`, which is what makes a cold launch with a stored token land straight on `MainTabView`. **Never construct a second one** — a fresh instance re-reads the Keychain and silently forks the session state.
- `LoginViewModel` calls `session.login(token:)` on success; `SettingsView`'s Log Out calls `session.logout()`. `RootView` observes `session.isAuthenticated`.
- `LoginState` deliberately has **no** `isLoggedIn` flag. Don't reintroduce one — it would be a second, non-persisted source of truth that disagrees with the Keychain after a relaunch.
- Login returns `AuthenticatedUser` (`user` + `token`), not `User`. The token is kept off the `User` entity on purpose: `User` describes a person, not a session.

### The Profile feature is deliberately outside this architecture

`FinTrack/Features/Profile/` has a `Presentation` folder only. `ProfileView.swift` calls `https://dummyjson.com/products` through the free `loadMore(skip:)` function using `URLSession.shared` directly, declares `ProductDTO` / `ProductsResponseDTO` in the view file, holds `@State` flags instead of a view model, and is constructed inline by `MainTabView` with no factory. Treat this as a scratch/spike area, not a pattern to copy — if Profile is built out for real, it needs the same four layers and a `ProfileFactory`, and the paging state below belongs in a view model.

Paging: `loadMore(skip:)` is the single pager (10 per page) used for the first page *and* every subsequent one. `loadFirstPage()` guards on `products.isEmpty` because `.task` re-runs whenever the tab is revisited; `loadNextPage()` is triggered by `.onAppear` on the last row and guards on `!isLoadingMore` plus `hasMorePages` (`products.count < total`) so the trigger can't run away. New pages are appended with an id de-dupe.

Navigation is value-based everywhere now: both Home (`HomeRoute`) and Profile (`ProfileRoute`) use `NavigationLink(value:)` + `navigationDestination(for:)`. Don't reintroduce the inline `NavigationLink { DestinationView() }` form — it bypasses `NavigationManager`, so those pushes can't be driven or reset programmatically.

## Project-file hazard (previously broke every build)

The target uses a `PBXFileSystemSynchronizedRootGroup` (`FinTrack/`), so the `Sources` build phase is intentionally empty — Xcode derives target membership from the folder. Two things had corrupted this and produced an `.app` with **no bundle executable** while still reporting `BUILD SUCCEEDED`, which made the simulator fail with "invalid argument" / "missing its bundle executable":

- A duplicate copy of the whole project had been saved *inside* the source tree at `FinTrack/Features/Auth/FinTrack.xcodeproj`, and it was the only one with a **shared** scheme. `-scheme FinTrack` therefore resolved to that copy, whose synchronized group pointed at a nonexistent `FinTrack/Features/Auth/FinTrack/` — zero sources compiled.
- The root `project.pbxproj` had accumulated five recursive `projectReferences` to `FinTrack.xcodeproj` itself, and its `productReference` pointed at an absolute `/Users/.../build/Debug-iphoneos/FinTrack.app` path.

Both are fixed and verified: the nested copy is gone, there are zero `projectReferences`, the product reference is `path = FinTrack.app; sourceTree = BUILT_PRODUCTS_DIR`, and the root project has a shared scheme at `FinTrack.xcodeproj/xcshareddata/xcschemes/FinTrack.xcscheme`.

Guard against regressions: never let an `.xcodeproj` or a built `.app` live under `FinTrack/`, and if a build succeeds suspiciously fast, confirm the log contains `SwiftCompile` and `Ld ... FinTrack.app/FinTrack` tasks attributed to `project 'FinTrack'` with no trailing path.

## Current state (in-progress scaffold)

Login → `MainTabView` → `HomeView` works end to end with mock data. Remaining rough edges — treat as unfinished, not intentional:

- Both `AuthAPI.login` and `HomeAPI.getDashBoardData` ignore the injected `NetworkClient` and decode a hardcoded JSON string literal. There is no base URL or endpoint layer yet, and login succeeds for any email/password.
- An artificial `Task.sleep(for: .seconds(3))` in `HomeAPI.getDashBoardData` simulates latency — a slow-looking Home first load is that, not a hang. Profile's `loadMore(skip:)` hits the network for real.
- Session persistence is real (Keychain), but the token it stores is the mock `"mock-access-token"` string from `AuthAPI`'s hardcoded JSON — nothing validates or refreshes it, and no request sends it. Attaching it as an `Authorization` header in `NetworkClient` and handling 401 → `session.logout()` is the next step when a real backend arrives.
- `HomeView` hardcodes some strings that should come from the entity: `Header` prints "Hello, Rizwan!" instead of its `userName` parameter, and the donut chart centre shows a fixed "$ 56420".
- `SpendingOverview.color` carries a hex string that `Color(hex:)` parses, so mock/API colors must be hex (`#16C784`), not names like `"green"`.
- Several identifiers are misspelled and load-bearing: `AppContainer.networlClient`, the file `HomeVieModel.swift` (type is `HomeViewModel`), the type `TranasactionDTO` (in the correctly-named `TransactionDTO.swift`), `QucikActions`/`QuicAction`, and the on-screen string "Spedning Overview". Match existing spelling when referencing them; rename deliberately, not incidentally.
