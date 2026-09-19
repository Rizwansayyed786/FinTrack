//
//  NavigationManager.swift
//  FinTrack
//

import SwiftUI

/// Owns every navigation stack in the signed-in shell.
///
/// Routes themselves stay feature-owned (`HomeRoute`, `ProfileRoute`, …) — this
/// type is deliberately generic over `Hashable` so `Core` never has to import a
/// feature. That keeps dependencies pointing inward while still giving one
/// place to drive navigation from.
@Observable
final class NavigationManager {

    enum Tab: Int, Hashable, CaseIterable {
        case home
        case settings
        case reports
        case profile
    }

    var selectedTab: Tab = .home

    // One path per tab, on purpose. A single shared `NavigationPath` would be
    // wrong here: every tab's NavigationStack reads the same value, so a push in
    // Home would also deepen Profile's stack.
    var homePath = NavigationPath()
    var settingsPath = NavigationPath()
    var reportsPath = NavigationPath()
    var profilePath = NavigationPath()

    // MARK: - Programmatic navigation

    func push<Route: Hashable>(_ route: Route, on tab: Tab) {
        mutatePath(of: tab) { $0.append(route) }
    }

    /// Switches tab, then pushes — the shape a deep link or notification needs.
    func push<Route: Hashable>(_ route: Route, switchingTo tab: Tab) {
        selectedTab = tab
        push(route, on: tab)
    }

    func pop(_ tab: Tab) {
        mutatePath(of: tab) { path in
            guard !path.isEmpty else { return }
            path.removeLast()
        }
    }

    func popToRoot(_ tab: Tab) {
        mutatePath(of: tab) { $0 = NavigationPath() }
    }

    /// Clears every stack and returns to Home. Call on logout so the next
    /// session doesn't inherit the previous user's navigation state.
    func reset() {
        selectedTab = .home
        homePath = NavigationPath()
        settingsPath = NavigationPath()
        reportsPath = NavigationPath()
        profilePath = NavigationPath()
    }

    private func mutatePath(of tab: Tab, _ mutate: (inout NavigationPath) -> Void) {
        switch tab {
        case .home: mutate(&homePath)
        case .settings: mutate(&settingsPath)
        case .reports: mutate(&reportsPath)
        case .profile: mutate(&profilePath)
        }
    }
}
