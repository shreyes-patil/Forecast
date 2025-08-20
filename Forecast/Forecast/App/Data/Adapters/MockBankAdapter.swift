//
//  MockBankAdapter.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation

private struct SeedAccountDTO : Decodable {
    let id: String
    let name: String
    let currentBalance : Decimal
    
}

private struct SeedTransactionDTO : Decodable {
    let id : String
    let date : String
    let amount : Decimal
    let category : String
    let merchant : String
    
}


final class MockBankAdapter : BankAdapter {
    private let accountsURL : URL
    private let transactionsURL : URL
    private let iso = ISO8601DateFormatter()
    
    init(accountsURL : URL = Bundle.main.url(forResource: "accounts", withExtension: "json")!,
         transactionsURL: URL = Bundle.main.url(forResource:"transactions", withExtension: "json")!)
    {
        self.accountsURL = accountsURL
        self.transactionsURL = transactionsURL
    }
    
    
    func connect() async throws {
//        after connection to plaid
    }
    
    func accounts() async throws -> [Account] {
        let data = try Data(contentsOf: accountsURL)
        let dtos = try JSONDecoder().decode([SeedAccountDTO].self, from: data)
        return dtos.map{Account(id: $0.id, name: $0.name, currentBalance: $0.currentBalance)}
    }
    
    func transactions() async throws -> [Transaction] {
        let data = try Data(contentsOf: transactionsURL)
        let dtos = try JSONDecoder().decode([SeedTransactionDTO].self, from: data)
        return dtos.compactMap { dto in
            guard let d = iso.date(from: dto.date) else { return nil }
            return Transaction(id: dto.id,
                               date: d,
                               amount: dto.amount,
                               category: dto.category,
                               merchant: dto.merchant
            )
        }
        .sorted(by: {$0.date > $1.date})
    }
    
        
    
    
    
}
