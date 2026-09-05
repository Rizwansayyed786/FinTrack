//
//  NetworkClient.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//
import Foundation

struct NetworkClient {
    
    func request(
        url: URL,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> Data {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.httpBody = body
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        let (data, response) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(
                httpResponse.statusCode
            )
        }
        
        return data
    }
}
