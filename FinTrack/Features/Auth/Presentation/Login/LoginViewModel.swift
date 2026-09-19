//
//  LoginViewModel.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 03/09/26.
//
import Foundation
import SwiftUI

@Observable
final class LoginViewModel  {
    var state = LoginState()
    
    private let useCase : LoginUsecases
    private let session : AuthSession
    
    init(loginUseCase : LoginUsecases, session : AuthSession){
        self.useCase = loginUseCase
        self.session = session
    }
    
    func login() async {
        state.isLoading = true
        state.errorMessage = nil
        
        do{
            let result = try await useCase.execute(email: state.email, password: state.password)
            // Persisting the token flips `session.isAuthenticated`, which is what
            // swaps `RootView` over to the tab shell.
            session.login(token: result.token)
            print("Login Succecfull as \(result.user.email)")
        }catch{
            self.state.errorMessage = error.localizedDescription
            print("Error Occured")
        }
        
        state.isLoading = false
    }
}
