//
//  AppContainer.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 02/09/26.
//

struct AppContainer {
    let networlClient: NetworkClient
    
    init() {
        let networlClient = NetworkClient()
        self.networlClient = networlClient
    }
    
    func makeLoginView() -> LoginView {
        AuthFactory.makeLoginView(
            networkclient: networlClient
        )
    }
    
    func makeHomeView() -> HomeView {
            HomeFactory.makeHomeView(
                networkClient: networlClient
            )
        }
    
}
