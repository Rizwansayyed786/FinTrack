//
//  UserModel.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//

struct UserModel: Decodable {
    let id: Int
    let name: String
    let email: String
    
    func toEntity() -> User {
        User(id: id, name: name, email: email)
    }
}
