//
//  MainView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI

struct Chat: View {
    @Environment(LanguageModelStore.self) private var languageModelStore
    @Environment(ConversationStore.self) private var conversationStore
    @Environment(AppStore.self) private var appStore
    @AppStorage("systemPrompt") private var systemPrompt: String = ""
    @AppStorage("defaultOllamaModel") private var defaultOllamaModel: String = ""
    @State var showMenu = false
    
    func toggleMenu() {
        withAnimation(.spring) {
            showMenu.toggle()
        }
        Haptics.shared.mediumTap()
    }
    
    @MainActor func sendMessage(prompt: String, model: LanguageModelSD, image: Image?, trimmingMessageId: String?) {
        conversationStore.sendPrompt(
            userPrompt: prompt,
            model: model,
            image: image,
            systemPrompt: systemPrompt,
            trimmingMessageId: trimmingMessageId
        )
    }
    
    func onConversationTap(_ conversation: ConversationSD) {
        withAnimation(.bouncy(duration: 0.3)) {
            Task {
                try await conversationStore.selectConversation(conversation)
                await languageModelStore.setModel(model: conversation.model)
            }
            showMenu.toggle()
        }
        Haptics.shared.mediumTap()
    }
    
    @MainActor func onStopGenerateTap() {
        conversationStore.stopGenerate()
        Haptics.shared.mediumTap()
    }
    
    func onConversationDelete(_ conversation: ConversationSD) {
        try? conversationStore.delete(conversation)
        Haptics.shared.mediumTap()
    }
    
    func onDeleteDailyCOnversatin(_ conversation: ConversationSD) {
        try? conversationStore.delete(conversation)
        Haptics.shared.mediumTap()
    }
    
    func newConversation() {
        withAnimation(.easeOut(duration: 0.3)) {
            conversationStore.selectedConversation = nil
        }
        Haptics.shared.mediumTap()
        
        Task {
            try? await languageModelStore.loadModels()
        }
    }
    
    var body: some View {
        Group {
#if os(macOS)
            ChatView(
                selectedConversation: conversationStore.selectedConversation,
                conversations: conversationStore.conversations,
                messages: conversationStore.messages,
                modelsList: languageModelStore.models,
                selectedModel: languageModelStore.selectedModel,
                onSelectModel: languageModelStore.setModel,
                onConversationTap:onConversationTap,
                onMenuTap: toggleMenu,
                onNewConversationTap: newConversation,
                onSendMessageTap: sendMessage,
                conversationState: conversationStore.conversationState,
                onStopGenerateTap: onStopGenerateTap,
                reachable: appStore.isReachable,
                modelSupportsImages: languageModelStore.supportsImages
            )
#else
            SideBarStack(sidebarWidth: 300,showSidebar: $showMenu, sidebar: {
                SidebarView(
                    conversations: conversationStore.conversations,
                    onConversationTap: onConversationTap,
                    onConversationDelete: onConversationDelete,
                    onDeleteDailyConversations: conversationStore.deleteDailyConversations
                )
            }) {
                ChatView(
                    conversation: conversationStore.selectedConversation,
                    messages: conversationStore.messages,
                    modelsList: languageModelStore.models,
                    selectedModel: languageModelStore.selectedModel,
                    onSelectModel: languageModelStore.setModel,
                    onMenuTap: toggleMenu,
                    onNewConversationTap: newConversation,
                    onSendMessageTap: sendMessage,
                    conversationState: conversationStore.conversationState,
                    onStopGenerateTap: onStopGenerateTap,
                    reachable: appStore.isReachable,
                    modelSupportsImages: languageModelStore.supportsImages
                )
            }
#endif
        }
        .onChange(of: languageModelStore.models, { _, modelsList in
            if languageModelStore.selectedModel == nil {
                if defaultOllamaModel != "" {
                    languageModelStore.setModel(modelName: defaultOllamaModel)
                } else {
                    languageModelStore.setModel(model: languageModelStore.models.first)
                }
            }
        })
        .onChange(of: conversationStore.selectedConversation, initial: true, { _, newConversation in
            if let conversation = newConversation {
                languageModelStore.setModel(model: conversation.model)
            } else {
                if defaultOllamaModel != "" {
                    languageModelStore.setModel(modelName: defaultOllamaModel)
                } else {
                    languageModelStore.setModel(model: languageModelStore.models.first)
                }
            }
        })
    }
}

#Preview {
    Chat()
}
