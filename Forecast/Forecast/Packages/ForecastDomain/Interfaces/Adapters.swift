//
//  Adapters.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation

 protocol BankAdapter : Sendable {
    
    func connect () async throws
    func accounts() async throws -> [Account]
    func transactions() async throws -> [Transaction]
}


 protocol ChatAdapter : Sendable {
    func answer(question : String, context : [Transaction]) async throws -> String
}
