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
    
    func login(email: String, password: String) async throws -> AuthenticatedUser {
        let json = """
        {
            "success": true,
            "message": "Login successful",
            "data": {
                "token": "mock-access-token",
                "user": {
                    "id": 123,
                    "name": "Rizwan",
                    "email": "rizwan@example.com"
                }
            }
        }
        """
        
        let data = Data(json.utf8)
        
        let response = try JSONDecoder().decode(
            APIResponseWrapper<LoginResponseDTO>.self,
            from: data
        )
        
        guard response.success else {
            throw APIError.server(response.message)
        }
        
        guard let loginData = response.data else {
            throw APIError.invalidResponse
        }
        
        return loginData.toEntity()
    }
}
