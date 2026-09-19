//
//  authFactory.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 02/09/26.
//
import Foundation

struct AuthFactory{
     static func makeRootView(networkclient : NetworkClient, session : AuthSession, container : AppContainer) -> RootView {
        let authAPI = AuthAPI(client: networkclient)
        
        let repository = AuthRepoImpl(api : authAPI)
        
        let useCase = LoginUsecases(userRepository : repository)
        
        let viewModel = LoginViewModel(loginUseCase : useCase, session : session)
        
        return RootView(viewModel: viewModel, session: session, container: container)
    }
}
