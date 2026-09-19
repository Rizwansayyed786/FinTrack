//
//  AppContainer.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 02/09/26.
//

struct AppContainer {
    let networlClient: NetworkClient
    /// One shared session for the whole app — it restores the Keychain token on
    /// creation, so it must be created once and injected, never re-made.
    let session: AuthSession
    /// One shared navigation manager. It outlives the tab shell, so navigation
    /// survives a tab-shell rebuild — and must be reset on logout.
    let navigation: NavigationManager
    
    init() {
        let networlClient = NetworkClient()
        self.networlClient = networlClient
        self.session = AuthSession(
            store: KeychainStore(service: "rizwan.FinTrack")
        )
        self.navigation = NavigationManager()
    }
    
    func makeRootView() -> RootView {
        AuthFactory.makeRootView(
            networkclient: networlClient,
            session: session,
            container: self
        )
    }
    
    func makeHomeView() -> HomeView {
        HomeFactory.makeHomeView(
            networkClient: networlClient
        )
    }
    
    func makeMainTabView() -> MainTabView {
        MainTabView(
            homeView: makeHomeView(),
            session: session
        )
    }
}
