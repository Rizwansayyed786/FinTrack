//
//  HomeAPI.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//
import Foundation
struct HomeAPI {
    private let client : NetworkClient
    init(client: NetworkClient) {
        self.client = client
    }
    
    func getDashBoardData() async throws -> Dashboard {
        
        try await Task.sleep(for : .seconds(3))
        let json = """
                {
                    "success": true,
                    "message": "Dashboard fetched successfully",
                    "data": {
                        "user": "Rizwan",
                        "balance": {
                            "total": 1000.00,
                            "percentagechange": 12.5
                        },
                        "spendingOverview": [
                            {
                                "id": "1",
                                "title": "Income",
                                "amount": 28,
                                "color": "#16C784"
                            },
                            {
                                "id": "2",
                                "title": "Expenses",
                                "amount": 10,
                                "color": "#EF4444"
                            }
                        ],
                        "transactions": [
                            {
                                "id": "1",
                                "amount": -50,
                                "date": "2026-09-07",
                                "merchant": "Big Bazaar",
                                "category": "Grocery"
                            },
                            {
                                "id": "2",
                                "amount": 2000,
                                "date": "2026-09-06",
                                "merchant": "Acme Corp",
                                "category": "Salary"
                            }
                        ]
                    }
                }
                """
        let data = Data(json.utf8)
        
        let response = try JSONDecoder().decode(
            APIResponseWrapper<DashboardDTO>.self, from: data)
       
        guard response.success else {
            throw APIError.server(response.message)
        }
        
        guard let dashbaordData = response.data else {
            throw APIError.invalidResponse
        }
        
        return dashbaordData.toEntity()
        
    }
}
