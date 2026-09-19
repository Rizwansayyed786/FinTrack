//
//  RootView.swift
//  FinTrack
//

import SwiftUI

/// Root of the app. Swaps between the login screen and the signed-in tab shell
/// instead of *pushing* the tab shell onto the login `NavigationStack` — a push
/// would make every tab's `NavigationStack` a nested stack inside a pushed
/// destination, which breaks `navigationDestination(for:)` in those tabs.
///
/// `AuthSession` restores its token from the Keychain during `init`, so a cold
/// launch with a stored token lands straight on `MainTabView`.
struct RootView: View {

    @State private var viewModel: LoginViewModel

    private let container: AppContainer
    private let session: AuthSession

    init(viewModel: LoginViewModel, session: AuthSession, container: AppContainer) {
        self.viewModel = viewModel
        self.session = session
        self.container = container
    }

    var body: some View {
        if session.isAuthenticated {
            // Navigation is app-wide state every screen in the shell may need, so
            // it goes in the environment rather than through each initialiser.
            container.makeMainTabView()
                .environment(container.navigation)
        } else {
            LoginView(viewModel: viewModel)
        }
    }
}
