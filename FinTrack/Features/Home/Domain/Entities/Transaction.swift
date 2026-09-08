//
//  Transaction.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 07/09/26.
//

struct Transaction : Identifiable{
    let id: String
    let amount: Int
    let date: String
    let merchant: String
    let category: String
}
