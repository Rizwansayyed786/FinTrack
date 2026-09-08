//
//  TransacitonDTO.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//
struct TranasactionDTO : Decodable{
    let id: String
    let amount: Int
    let date: String
    let merchant: String
    let category: String
}

extension TranasactionDTO{
    func toEntity() -> TransactionSpending{
        return TransactionSpending(id: id, amount: amount, date: date, merchant: merchant, category: category)
    }
}
