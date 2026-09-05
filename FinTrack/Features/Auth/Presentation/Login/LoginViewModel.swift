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
    
    init(loginUseCase : LoginUsecases){
        self.useCase = loginUseCase
    }
    
    func login() async {
        state.isLoading = true
        state.errorMessage = nil
        
        do{
            let user = try await useCase.execute(email: state.email, password: state.password)
            self.state.isLoggedIn = true
            print("Login Succecfull as \(user.email)")
        }catch{
            self.state.errorMessage = error.localizedDescription
            print("Error Occured")
        }
        
        state.isLoading = false
    }
}
