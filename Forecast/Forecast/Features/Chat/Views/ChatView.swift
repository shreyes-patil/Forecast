//
//  ChatView.swift
//  Forecast
//
//  Created by Shreyas Patil on 8/21/25.
//


import SwiftUI

 struct ChatView: View {
    @StateObject private var vm: ChatViewModel
    @FocusState private var inputFocused: Bool
    @State private var scrollID = UUID()

    public init(viewModel: ChatViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            if let err = vm.errorMessage {
                ErrorBanner(text: err) { vm.errorMessage = nil }
            }

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.messages) { msg in
                            MessageBubble(message: msg)
                                .id(msg.id)
                                .padding(.horizontal, 12)
                        }

                        if vm.isSending {
                            TypingBubble()
                                .padding(.horizontal, 12)
                        }
                    }
                    .padding(.vertical, 12)
                }
                .onChange(of: vm.messages) { _ in
                    scrollToBottom(proxy)
                }
                .onChange(of: vm.isSending) { _ in
                    scrollToBottom(proxy)
                }
                .onAppear {
                    vm.loadInitial()
                    // Initial scroll after first render
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        scrollToBottom(proxy)
                    }
                }
            }

            ComposerBar(
                text: $vm.inputText,
                isSending: vm.isSending,
                onSend: {
                    inputFocused = false
                    vm.send()
                },
                onStop: {
                    vm.cancelSending()
                }
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .focused($inputFocused)
        }
        .navigationTitle("AI Chat")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let lastID = vm.messages.last?.id else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            proxy.scrollTo(lastID, anchor: .bottom)
        }
    }
}

// MARK: - Subviews

private struct MessageBubble: View {
    let message: ChatMessage

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 48) }

            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .font(.body)
                    .foregroundStyle(isUser ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isUser ? Color.accentColor : Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Text(message.date, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 6)
            }
            .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)

            if !isUser { Spacer(minLength: 48) }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isUser ? "You" : "Assistant")
    }
}

private struct TypingBubble: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 56, height: 32)
                    .overlay(
                        HStack(spacing: 4) {
                            Dot()
                            Dot().animation(.easeInOut(duration: 0.9).repeatForever(), value: UUID())
                            Dot().animation(.easeInOut(duration: 1.2).repeatForever(), value: UUID())
                        }
                    )
            }
            Spacer()
        }
        .onAppear {} 
    }

    private struct Dot: View {
        @State private var up = false
        var body: some View {
            Circle()
                .frame(width: 6, height: 6)
                .foregroundStyle(.secondary)
                .offset(y: up ? -2 : 2)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        up.toggle()
                    }
                }
        }
    }
}

private struct ComposerBar: View {
    @Binding var text: String
    let isSending: Bool
    let onSend: () -> Void
    let onStop: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("Ask about your spending…", text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...4)
                .disableAutocorrection(false)
                .submitLabel(.send)
                .onSubmit { if canSend { onSend() } }

            if isSending {
                Button(action: onStop) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .accessibilityLabel("Stop")
            } else {
                Button(action: { if canSend { onSend() } }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canSend)
                .accessibilityLabel("Send")
            }
        }
    }

    private var canSend: Bool { !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}

private struct ErrorBanner: View {
    let text: String
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
            Text(text).lineLimit(2)
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark")
            }
        }
        .font(.footnote)
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding([.horizontal, .top], 12)
    }
}
