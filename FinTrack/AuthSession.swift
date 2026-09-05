//
//  AuthSession.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 04/09/26.
//

class AuthSession{
    var authenticated: Bool = false
    
    func login() {
        authenticated = true
        
    }
    func logout() {
        authenticated = false
    }
}
