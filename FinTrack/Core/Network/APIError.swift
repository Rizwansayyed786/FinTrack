//
//  APIError.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//
import Foundation

enum APIError: Error, LocalizedError {

    case invalidResponse
    case httpError(Int)
    case server(String)

    var errorDescription: String? {
        switch self {

        case .invalidResponse:
            return "Invalid server response"

        case .httpError(let statusCode):
            return "Server error: \(statusCode)"

        case .server(let message):
            return message
        }
    }
}
