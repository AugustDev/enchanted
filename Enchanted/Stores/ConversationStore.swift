//
//  ChatsStore.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import Foundation
import SwiftData
import OllamaKit
import Combine
import SwiftUI

@Observable
final class ConversationStore {
    private var swiftDataService: SwiftDataService
    private var generation: AnyCancellable?
    
    /// For some reason (SwiftUI bug / too frequent UI updates) updating UI for each stream message sometimes freezes the UI.
    /// Throttling UI updates seem to fix the issue.
    private var currentMessageBuffer: String = ""
    private let throttler = Throttler(delay: 0.25)
    
    var conversationState: ConversationState = .completed
    var conversations: [ConversationSD] = []
    var selectedConversation: ConversationSD?
    @MainActor var messages: [MessageSD] = []
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
    }
    
    @MainActor
    func loadConversations() async throws {
        print("loading conversations")
        conversations = try swiftDataService.fetchConversations()
        print("loaded conversations")
    }
    
    func deleteAllConversations() {
        Task {
            DispatchQueue.main.async { [self] in
                messages = []
            }
            selectedConversation = nil
            try? swiftDataService.deleteConversations()
            try? await loadConversations()
        }
    }
    
    func deleteDailyConversations(_ date: Date) {
        Task {
            DispatchQueue.main.async { [self] in
                messages = []
            }
            selectedConversation = nil
            try? swiftDataService.deleteConversations()
            try? await loadConversations()
        }
    }
    
    func create(_ conversation: ConversationSD) throws {
        try swiftDataService.createConversation(conversation)
    }
    
    @MainActor func reloadConversation(_ conversation: ConversationSD) throws {
        selectedConversation = try swiftDataService.getConversation(conversation.id)
        messages = try swiftDataService.fetchMessages(conversation.id)
    }
    
    @MainActor func selectConversation(_ conversation: ConversationSD) throws {
        try reloadConversation(conversation)
    }
    
    func delete(_ conversation: ConversationSD) throws {
        selectedConversation = nil
        try swiftDataService.deleteConversation(conversation)
        conversations = try swiftDataService.fetchConversations()
    }
    
    //    @MainActor
    @MainActor func stopGenerate() {
        generation?.cancel()
        handleComplete()
        withAnimation {
            conversationState = .completed
        }
    }
    
    @MainActor
    func sendPrompt(userPrompt: String, model: LanguageModelSD, image: Image?, systemPrompt: String = "") {
        guard userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
        
        let conversation = selectedConversation ?? ConversationSD(name: userPrompt)
        conversation.updatedAt = Date.now
        conversation.model = model
        
        print("model", model.name)
        print("conversation", conversation.name)
        
        /// add system prompt to very first message in the conversation
        if !systemPrompt.isEmpty && conversation.messages.isEmpty {
            let systemMessage = MessageSD(content: systemPrompt, role: "system")
            systemMessage.conversation = conversation
        }
        
        let userMessage = MessageSD(content: userPrompt, role: "user", image: image?.render()?.compressImageData())
        userMessage.conversation = conversation
        
        var messageHistory = conversation.messages
            .sorted{$0.createdAt < $1.createdAt}
            .map{ChatMessage(role: $0.role, content: $0.content)
            }
        
        /// attach selected image to the last Message
        if let lastMessage = messageHistory.popLast() {
            var imagesBase64: [String] = []
            if let image = image?.render() {
                imagesBase64.append(image.convertImageToBase64String())
            }
            
            let messageWithImage = ChatMessage(role: lastMessage.role, content: lastMessage.content, images: imagesBase64)
            messageHistory.append(messageWithImage)
        }
        
        let assistantMessage = MessageSD(content: "", role: "assistant")
        assistantMessage.conversation = conversation
        
        conversationState = .loading
        
        Task {
            try swiftDataService.updateConversation(conversation)
            try swiftDataService.createMessage(userMessage)
            try swiftDataService.createMessage(assistantMessage)
            try reloadConversation(conversation)
            try? await loadConversations()
            
            if await OllamaService.shared.ollamaKit.reachable() {
                let request = OkChatRequestData(model: model.name, messages: messageHistory)
                generation = OllamaService.shared.ollamaKit.chat(data: request)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .finished:
                            self?.handleComplete()
                        case .failure(let error):
                            self?.handleError(error.localizedDescription)
                        }
                    }, receiveValue: { [weak self] response in
                        self?.handleReceive(response)
                    })
            } else {
                self.handleError("Server unreachable")
            }
        }
    }
    
    @MainActor
    private func handleReceive(_ response: OKChatResponse)  {
        if messages.isEmpty { return }
        
        if let responseContent = response.message?.content {
            currentMessageBuffer = currentMessageBuffer + responseContent
            
            throttler.throttle { [weak self] in
                guard let self = self else { return }
                let lastIndex = self.messages.count - 1
                self.messages[lastIndex].content.append(currentMessageBuffer)
                currentMessageBuffer = ""
            }
        }
    }
    
        @MainActor
    private func handleError(_ errorMessage: String) {
        guard let lastMesasge = messages.last else { return }
        lastMesasge.error = true
        lastMesasge.done = false
        
        Task(priority: .background) {
            try? swiftDataService.updateMessage(lastMesasge)
        }
        
        withAnimation {
            conversationState = .error(message: errorMessage)
        }
    }
    
        @MainActor
    private func handleComplete() {
        guard let lastMesasge = messages.last else { return }
        lastMesasge.error = false
        lastMesasge.done = true
        
        Task(priority: .background) {
            try self.swiftDataService.updateMessage(lastMesasge)
        }
        
        withAnimation {
            conversationState = .completed
        }
    }
}
