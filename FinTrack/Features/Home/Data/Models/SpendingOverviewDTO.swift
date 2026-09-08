//
//  SpendingOverviewDTO.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//
struct SpendingOverviewDTO : Decodable{
    let id: String
    let title: String
    let amount: Double
    let color: String
}

extension SpendingOverviewDTO {
    func toEntity() -> SpendingOverview {
        return SpendingOverview(id : id,title: title, amount: amount, color: color)
    }
}
