//
//  LoginUsecases.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//

struct LoginUsecases {
    private let repository: AuthRepository
    
    init(userRepository : AuthRepository){
        self.repository = userRepository
    }
    
    func execute(
        email : String,
        password : String
    ) async throws -> User{
        return try await repository.login(email: email, password: password)
    }
}
