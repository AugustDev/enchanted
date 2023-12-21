//
//  MainView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI

struct MainView: View {
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
    
    @MainActor func sendMessage(prompt: String, model: LanguageModelSD) {
        conversationStore.sendPrompt(userPrompt: prompt, model: model)
    }
    
    func onConversationTap(_ conversation: ConversationSD) {
        withAnimation(.bouncy(duration: 0.3)) {
            do {
                try conversationStore.selectConversation(conversation)
                languageModelStore.selectedModel = conversation.model
            } catch {
                
            }
            showMenu.toggle()
        }
    }
    
//    @MainActor 
    func onStopGenerateTap() {
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
                onMenuTap: toggleMenu,
                onNewConversationTap: newConversation,
                onSendMessageTap: sendMessage, 
                conversationState: conversationStore.conversationState, 
                onStopGenerateTap: onStopGenerateTap,
                reachable: appStore.isReachable
            )
        }
    }
}

#Preview {
    MainView()
}
