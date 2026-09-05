//
//  authFactory.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 02/09/26.
//
import Foundation

struct AuthFactory{
     static func makeLoginView(networkclient : NetworkClient) -> LoginView {
        let authAPI = AuthAPI(client: networkclient)
        
        let repository = AuthRepoImpl(api : authAPI)
        
        let useCase = LoginUsecases(userRepository : repository)
        
        let viewModel = LoginViewModel(loginUseCase : useCase)
        
        return LoginView(viewModel: viewModel)
    }
}
