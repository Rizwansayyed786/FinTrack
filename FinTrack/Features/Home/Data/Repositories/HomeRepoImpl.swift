//
//  HomeRepoImpl.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//

class HomeRepoImpl: HomeRepository {
    private let api: HomeAPI
    init(api: HomeAPI) {
        self.api = api
    }
    
    func getDashboardData() async throws -> Dashboard {
        return try await api.getDashBoardData();
    }
}
