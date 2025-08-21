//
//  MockAccountRepository.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//


import Foundation

final class MockAccountRepository: AccountRepository {
    func fetchAccounts() async throws -> [Account] {
        guard let url = Bundle.main.url(forResource: "accounts", withExtension: "json") else {
            throw NSError(domain: "MockAccountRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "accounts.json not found"])
        }
        
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode([AccountDTO].self, from: data)
        return decoded.map { $0.toDomain() }
    }
}

private struct AccountDTO: Decodable {
    let id: String
    let name: String
    let currentBalance: Double
    
    func toDomain() -> Account {
        Account(id: id, name: name, currentBalance: Decimal(currentBalance))
    }
}
