//
//  AppDependecies.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation


struct AppDependecies {
    let bankAdapter: BankAdapter
    let chatAdapter: ChatAdapter
    
    let transactionStore: TransactionStore
    let transactionRepository: TransactionRepository
    
    static func live () -> AppDependecies {
        let bank = MockBankAdapter()
        let chat = MockChatAdapter()
        
        let txStore = InMemoryTransactionStore()
        let txRepo = TransactionRepositoryImpl(bank: bank, store: txStore)
        
        return AppDependecies(
            bankAdapter: bank, chatAdapter: chat, transactionStore: txStore, transactionRepository: txRepo)
        
    }
    
}
