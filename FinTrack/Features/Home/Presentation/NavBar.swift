import SwiftUI
struct MainTabView: View {

    let homeView: HomeView
    let session: AuthSession

    @Environment(NavigationManager.self) private var navigation

    var body: some View {
        @Bindable var navigation = navigation

        TabView(selection: $navigation.selectedTab) {

            NavigationStack(path: $navigation.homePath) {
                homeView
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(NavigationManager.Tab.home)

            NavigationStack(path: $navigation.settingsPath) {
                SettingsView(session: session)
            }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(NavigationManager.Tab.settings)

            NavigationStack(path: $navigation.reportsPath) {
                Text("Reports")
            }
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Reports")
                }
                .tag(NavigationManager.Tab.reports)

            NavigationStack(path: $navigation.profilePath) {
                ProfileView()
            }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(NavigationManager.Tab.profile)
        }
    }
}

/// Placeholder Settings tab. Exists mainly to host logout, which clears the
/// Keychain token and drops `RootView` back to the login screen.
struct SettingsView: View {

    let session: AuthSession

    @Environment(NavigationManager.self) private var navigation

    var body: some View {
        List {
            Section {
                Button("Log Out", role: .destructive) {
                    session.logout()
                    // Stacks live in the container and outlive the tab shell, so
                    // clear them or the next sign-in resumes mid-navigation.
                    navigation.reset()
                }
            }
        }
        .navigationTitle("Settings")
    }
}
