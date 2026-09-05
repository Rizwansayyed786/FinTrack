//
//  AuthAPI.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//
import Foundation

struct AuthAPI {
    private let client : NetworkClient
    init(client: NetworkClient) {
        self.client = client
    }
    
    func login(email: String, password: String) async throws -> User {
        let json = """
        {
            "success": true,
            "message": "Login successful",
            "data": {
                "id": 123,
                "name": "Rizwan",
                "email": "rizwan@example.com"
            }
        }
        """
        
        let data = Data(json.utf8)
        
        let response = try JSONDecoder().decode(
            APIResponseWrapper<UserModel>.self,
            from: data
        )
        
        guard response.success else {
            throw APIError.server(response.message)
        }
        
        guard let user = response.data else {
            throw APIError.invalidResponse
        }
        
        return user.toEntity()
    }
}
