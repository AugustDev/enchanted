//
//  PromptPanel.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

import SwiftUI

struct PromptPanel: View {
    @AppStorage("systemPrompt") private var systemPrompt: String = ""
    @State var conversationStore = ConversationStore.shared
    @State var languageModelStore = LanguageModelStore.shared
    var onSubmitPanel: () -> ()
    
    @MainActor
    func sendMessage(prompt: String) {
        conversationStore.selectedConversation = nil
        conversationStore.sendPrompt(
            userPrompt: prompt,
            model: languageModelStore.selectedModel!,
            systemPrompt: systemPrompt
        )
        onSubmitPanel()
    }
    
    var body: some View {
        PromptPanelView(onSubmit: sendMessage)
    }
}
