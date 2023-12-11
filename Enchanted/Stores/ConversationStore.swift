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
    
    var prompt: String = ""
    var conversationState: ConversationState = .completed
    var conversations: [ConversationSD] = []
    var selectedConversation: ConversationSD?
    var messages: [MessageSD] = []
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
    }
    
    @MainActor
    func loadConversations() async throws {
        conversations = try swiftDataService.fetchConversations()
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
        
        let context = conversation.messages.last?.context ?? []
        
        let message = MessageSD(prompt: userPrompt)
        message.context = context
        message.conversation = conversation
        conversationState = .loading
        
        Task {
            try swiftDataService.updateConversation(conversation)
            try swiftDataService.createMessage(message)
            try reloadConversation(conversation)
            try? await loadConversations()
            
            if await OllamaService.shared.ollamaKit.reachable() {
                var request = OKGenerateRequestData(model: message.model, prompt: userPrompt)
                request.context = context
                
                print(request)
                
                generation = OllamaService.shared.ollamaKit.generate(data: request)
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
        
        prompt = ""
        
    }
    
    private func handleReceive(_ response: OKGenerateResponse)  {
        if messages.isEmpty { return }
        
        let lastIndex = messages.count - 1
        let currentResponse = messages[lastIndex].response ?? ""
        if let responseContext = response.context {
            if responseContext.count > 0 {
                print(responseContext)
                let currentContext = messages[lastIndex].context ?? []
                print(responseContext.count, currentContext.count)
                messages[lastIndex].context = currentContext + responseContext
            }
        }
        messages[lastIndex].response = currentResponse + response.response
        conversationState = .loading
    }
    
    private func handleError(_ errorMessage: String) {
        guard let lastMesasge = messages.last else { return }
        lastMesasge.error = true
        lastMesasge.done = false
        try? swiftDataService.updateMessage(lastMesasge)
        withAnimation {
            conversationState = .error(message: errorMessage)
        }
    }
    
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
