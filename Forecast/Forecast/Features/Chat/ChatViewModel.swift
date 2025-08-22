//
//  ChatViewModel.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//

import Foundation

@MainActor
final class ChatViewModel: ObservableObject {

    private let chat: ChatAdapter
    private let txRepo: TransactionRepository

    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isSending: Bool = false
    @Published var errorMessage: String?

    private var inFlightTask: Task<Void, Never>?

    init(chat: ChatAdapter, txRepo: TransactionRepository) {
        self.chat = chat
        self.txRepo = txRepo
    }

    func loadInitial() {
        guard messages.isEmpty else { return }
        messages.append(
            ChatMessage(
                role: .system,
                text: "Ask a what‑if like “Can I afford $200 more in groceries this month?” or “What happens if rent goes up 5%?”"
            )
        )
    }

    func send() {
        let question = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty, !isSending else { return }

        errorMessage = nil
        inputText = ""
        messages.append(ChatMessage(role: .user, text: question))

        inFlightTask?.cancel()

        isSending = true
        inFlightTask = Task { [weak self] in
            guard let self else { return }
            do {
                let tx = try await txRepo.fetchTransactions(forceRefresh: false)
                let recent = Array(tx.sorted(by: { $0.date > $1.date }).prefix(20))
                let answer = try await chat.answer(question: question, context: recent)

                try Task.checkCancellation()
                await MainActor.run {
                    self.messages.append(ChatMessage(role: .assistant, text: answer))
                    self.isSending = false
                }
            } catch is CancellationError {
                await MainActor.run { self.isSending = false }
            } catch {
                await MainActor.run {
                    self.errorMessage = (error as NSError).localizedDescription
                    self.isSending = false
                }
            }
        }
    }

    func cancelSending() {
        inFlightTask?.cancel()
        isSending = false
    }
}
