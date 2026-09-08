//
//  HomeRepository.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//

protocol HomeRepository {
    func getDashboardData() async throws -> Dashboard
}
