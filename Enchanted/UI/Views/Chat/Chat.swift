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
    @State var showMenu = false
    
//    @MainActor
    func toggleMenu() {
        withAnimation(.spring) {
            showMenu.toggle()
        }
    }
    
    @MainActor func sendMessage(prompt: String, model: LanguageModelSD, image: Image?) {
        conversationStore.sendPrompt(userPrompt: prompt, model: model, image: image)
    }
    
    func onConversationTap(_ conversation: ConversationSD) {
        withAnimation(.bouncy(duration: 0.3)) {
            do {
                Task {
                    try await conversationStore.selectConversation(conversation)
                    await languageModelStore.setModel(model: conversation.model)
                }
            } catch {
                
            }
            showMenu.toggle()
        }
    }
    
    @MainActor func onStopGenerateTap() {
        conversationStore.stopGenerate()
    }
    
    func onConversationDelete(_ conversation: ConversationSD) {
        try? conversationStore.delete(conversation)
    }
    
    func newConversation() {
        withAnimation(.easeOut(duration: 0.3)) {
            conversationStore.selectedConversation = nil
        }
    }
    
    var body: some View {
        SideBarStack(sidebarWidth: 300,showSidebar: $showMenu, sidebar: {
            SidebarView(
                conversations: conversationStore.conversations,
                onConversationTap: onConversationTap,
                onConversationDelete: onConversationDelete
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
    }
}

#Preview {
    Chat()
}
