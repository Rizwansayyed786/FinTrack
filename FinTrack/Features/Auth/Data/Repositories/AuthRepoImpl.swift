//
//  AuthRepoImpl.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//

class AuthRepoImpl : AuthRepository {
    private let api : AuthAPI
    
    init(api: AuthAPI) {
        self.api = api
    }
    
    func login(email: String, password: String) async throws -> User {
       let response = try await api.login(email: email, password: password)
    return response
    }
}
