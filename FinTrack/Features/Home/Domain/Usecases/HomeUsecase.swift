//
//  Untitled.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//

struct HomeUsecase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> Dashboard {
        try await repository.getDashboardData()
    }
}
