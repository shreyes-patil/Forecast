//
//  MockChatAdapter.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/20/25.
//

import Foundation

final class MockChatAdapter: ChatAdapter {
    func answer(question: String, context: [Transaction]) async throws -> String {
        return "Mocked answer for: \(question). (Context size : \(context.count) transactions)"
    }
}
