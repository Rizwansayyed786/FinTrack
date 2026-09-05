//
//  AuthRepository.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//

protocol AuthRepository {
    func login(email:String,password : String) async throws -> User
}
