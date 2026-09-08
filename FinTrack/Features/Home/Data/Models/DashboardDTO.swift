//
//  DashboardDTO.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//

struct DashboardDTO : Decodable {
    let user: String
    let balance: BalanceDTO
    let transactions: [TranasactionDTO]
    let spendingOverview: [SpendingOverviewDTO]
}


extension DashboardDTO{
    func toEntity() -> Dashboard {
        Dashboard(
            name : user,
            balance: balance.toEntity(),
            transactions: transactions.map { $0.toEntity() },
            spendingOverview: spendingOverview.map { $0.toEntity() },
        )
    }

}
