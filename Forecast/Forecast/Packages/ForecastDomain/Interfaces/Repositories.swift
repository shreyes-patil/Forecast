//
//  Repositories.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


 protocol AccountRepository: Sendable {
    func fetchAccounts() async throws -> [Account]
    
}


 protocol TransactionRepository: Sendable {
    func fetchTransactions(forceRefresh : Bool) async throws -> [Transaction]
}
