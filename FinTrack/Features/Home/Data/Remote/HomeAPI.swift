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
        let json = """
                {
                    "success": true,
                    "message": "Dashboard fetched successfully",
                    "data": {
                        "userName": "Rizwan",
                        "balance": {
                            "total": 1000.00,
                            "changePercentage": 12.5
                        },
                        "spendingOverview": [
                            {
                                "id": "1"
                                "title": "Income",
                                "value": 0.28,
                                "color": "green"
                            },
                            {
                                "id":"2"
                                "title": "Expenses",
                                "value": 0.10,
                                "color": "red"
                            }
                        ],
                        "recentTransactions": [
                            {
                                "id": "1",
                                "title": "Grocery",
                                "amount": -50.00,
                                "date": "2026-09-07"
                            },
                            {
                                "id": "2",
                                "title": "Salary",
                                "amount": 2000.00,
                                "date": "2026-09-06"
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
