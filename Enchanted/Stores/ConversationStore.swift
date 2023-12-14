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
    
    var conversationState: ConversationState = .completed
    var conversations: [ConversationSD] = []
    var selectedConversation: ConversationSD?
    var messages: [MessageSD] = []
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
    }
    
    @MainActor
    func loadConversations() async throws {
        print("loading conversations")
        conversations = try swiftDataService.fetchConversations()
        print("loaded conversations")
    }
    
    func create(_ conversation: ConversationSD) throws {
        try swiftDataService.createConversation(conversation)
    }
    
    func reloadConversation(_ conversation: ConversationSD) throws {
        selectedConversation = try swiftDataService.getConversation(conversation.id)
        messages = try swiftDataService.fetchMessages(conversation.id)
    }
    
    func selectConversation(_ conversation: ConversationSD) throws {
        try reloadConversation(conversation)
    }
    
//    @MainActor 
    func stopGenerate() {
        generation?.cancel()
        handleComplete()
        withAnimation {
            conversationState = .completed
        }
    }
    
    @MainActor
    func sendPrompt(userPrompt: String, model: LanguageModelSD) {
        guard userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
        
        let conversation = selectedConversation ?? ConversationSD(name: userPrompt)
        conversation.updatedAt = Date.now
        conversation.model = model
        
        print(conversation.name)
        print(conversation.messages)
        print(conversation.model?.name ?? "")
        
        let userMessage = MessageSD(content: userPrompt, role: "user")
        userMessage.conversation = conversation

        let messageHistory = conversation.messages
            .sorted{$0.createdAt < $1.createdAt}
            .map{ChatMessage(role: $0.role, content: $0.content)
        }
        
        let assistantMessage = MessageSD(content: "", role: "assistant")
        assistantMessage.conversation = conversation
        
        conversationState = .loading
        print("msg received")
        
        Task {
            try swiftDataService.updateConversation(conversation)
            try swiftDataService.createMessage(userMessage)
            try swiftDataService.createMessage(assistantMessage)
            try reloadConversation(conversation)
            try? await loadConversations()
            
            if await OllamaService.shared.ollamaKit.reachable() {
                let request = OkChatRequestData(model: model.name, messages: messageHistory)
                print(request)
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
    
//    @MainActor
    private func handleReceive(_ response: OKChatResponse)  {
        DispatchQueue.main.async { [self] in
            if messages.isEmpty { return }
            
            let lastIndex = messages.count - 1
            let currentContent = messages[lastIndex].content

            if let responseContent = response.message?.content {
                messages[lastIndex].content = currentContent + responseContent
            }
            conversationState = .loading
        }
    }
    
//    @MainActor
    private func handleError(_ errorMessage: String) {
        guard let lastMesasge = messages.last else { return }
        lastMesasge.error = true
        lastMesasge.done = false
        try? swiftDataService.updateMessage(lastMesasge)
        withAnimation {
            conversationState = .error(message: errorMessage)
        }
    }
    
//    @MainActor
    private func handleComplete() {
        guard let lastMesasge = messages.last else { return }
        lastMesasge.error = false
        lastMesasge.done = true
        try? swiftDataService.updateMessage(lastMesasge)
        
        withAnimation {
            conversationState = .completed
        }
    }
}
