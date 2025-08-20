//
//  Repositories.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


public protocol AccountRepositories: Sendable {
    func fetchAccounts() async throws -> [Account]
    
}


public protocol TransactionRepositories: Sendable {
    func fetchTransactions(forceRefresh : Bool) async throws -> [Transaction]
}
