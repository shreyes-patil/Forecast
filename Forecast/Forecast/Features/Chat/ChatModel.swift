//
//  ChatModel.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//

import Foundation

public enum ChatRole: String, Sendable {
    case user
    case assistant
    case system
}

public struct ChatMessage: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let role: ChatRole
    public let text: String
    public let date: Date

    public init(id: UUID = UUID(), role: ChatRole, text: String, date: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.date = date
    }
}
