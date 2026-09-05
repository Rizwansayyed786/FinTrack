//
//  APIResponseWrapper.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//

struct APIResponseWrapper<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}
