//
//  ForecastApp.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import SwiftUI

@main
struct ForecastApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView(
                accountRepo: MockAccountRepository(),
                transactionRepo: TransactionRepositoryImpl(
                    bank: MockBankAdapter(),
                    store: InMemoryTransactionStore()
                ),
                chatAdapter: MockChatAdapter()
            )
        }
    }
}
