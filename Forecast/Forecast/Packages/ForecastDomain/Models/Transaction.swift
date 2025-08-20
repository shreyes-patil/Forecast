//
//  Transaction.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


public struct Transaction: Sendable, Equatable {
    public let id : String
    public let date : Date
    public let amount : Decimal
    public let category : String
    public let merchant : String
    
    public init(id: String, date: Date, amount: Decimal, category: String, merchant: String) {
        self.id = id
        self.date = date
        self.amount = amount
        self.category = category
        self.merchant = merchant
    }
}
