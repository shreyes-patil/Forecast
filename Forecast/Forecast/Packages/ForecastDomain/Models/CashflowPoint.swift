//
//  CashFlowPoint.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


public struct CashFlowPoint {
    public let date: Date
    public let balance: Decimal
    
    public init(date: Date, balance: Decimal) {
        self.date = date
        self.balance = balance
    }
}
