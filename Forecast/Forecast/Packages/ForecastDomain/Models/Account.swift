//
//  Account.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


public struct Account : Sendable, Equatable{
    public let id : String
    public let name : String
    public let currentBalance :   Decimal
    
    public init(id: String, name: String, currentBalance: Decimal) {
        self.id = id
        self.name = name
        self.currentBalance = currentBalance
    }
}
