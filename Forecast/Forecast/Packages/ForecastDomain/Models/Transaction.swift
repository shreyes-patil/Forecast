//
//  Transaction.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


struct Transaction: Sendable, Equatable {
    let id : String
    let date : Date
    let amount : Decimal
    let category : String
    let merchant : String
    
 
}
