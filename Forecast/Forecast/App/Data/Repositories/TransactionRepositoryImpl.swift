//
//  TransactionRepositories.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


protocol TransactionStore: Sendable {
    func load() async throws -> [Transaction]
    func save(_ txs : [Transaction]) async throws
}

final class TransactionRepositoryImpl : TransactionRepository {
    private let bank : BankAdapter
    private let store : TransactionStore
    
    init(bank : BankAdapter, store : TransactionStore) {
        self.bank = bank
        self.store = store
    }
    
    func fetchTransactions(forceRefresh: Bool) async throws -> [Transaction] {
        if !forceRefresh {
            if let cached = try? await store.load(), !cached.isEmpty{
                return cached
            }
        }
        
        let fresh = try await bank.transactions()
        try await store.save(fresh)
        return fresh
    }
}


