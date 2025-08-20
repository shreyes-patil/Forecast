//
//  InMemoryTransactionStore.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


actor InMemoryTransactionStore : TransactionStore {
    private var cached : [Transaction] = []
    
    
    func load() async throws -> [Transaction] {
        cached
    }
    
    func save(_ txs: [Transaction]) async throws {
        cached = txs
    }
    
    
}
