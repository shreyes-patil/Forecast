//
//  AccountRepositoryImpl.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//

import Foundation


final class AccountRepositoryImpl: AccountRepository {
    private let bank : BankAdapter
    
    init(bank: BankAdapter) {
        self.bank = bank
    }
    
    func fetchAccounts() async throws -> [Account] {
        try await bank.accounts()
    }
}
