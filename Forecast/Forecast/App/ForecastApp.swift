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
            // Dependencies (mocks for now)
            let bank = MockBankAdapter()
            let txStore = InMemoryTransactionStore()
            let txRepo = TransactionRepositoryImpl(bank: bank, store: txStore)
            let acctRepo = MockAccountRepository()

            DashboardView(
                viewModel: DashboardViewModel(
                    accountRepo: acctRepo,
                    transactionRepo: txRepo
                )
            )
        }
    }
}
