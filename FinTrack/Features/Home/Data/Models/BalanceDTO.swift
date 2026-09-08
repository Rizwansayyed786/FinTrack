//
//  BalanceDTO.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//

struct BalanceDTO : Decodable{
    let total: Double
    let percentagechange: Double
}

extension BalanceDTO{
    func toEntity() -> Balance{
        return Balance(total: total, percentagechange: percentagechange)
    }
}
