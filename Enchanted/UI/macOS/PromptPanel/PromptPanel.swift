//
//  PromptPanel.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

#if os(macOS)
import SwiftUI

struct PromptPanel: View {
    @AppStorage("colorScheme") private var colorScheme: AppColorScheme = .system
    @AppStorage("systemPrompt") private var systemPrompt: String = ""
    @State var conversationStore = ConversationStore.shared
    @State var languageModelStore = LanguageModelStore.shared
    var onSubmitPanel: () -> ()
    var onLayoutUpdate: () -> ()
    
    @MainActor
    func sendMessage(prompt: String, image: Image?) {
        conversationStore.selectedConversation = nil
        conversationStore.sendPrompt(
            userPrompt: prompt,
            model: languageModelStore.selectedModel!,
            image: image,
            systemPrompt: systemPrompt
        )
        onSubmitPanel()
    }
    
    var body: some View {
        PromptPanelView(onSubmit: sendMessage, onLayoutUpdate: onLayoutUpdate, imageSupport: languageModelStore.selectedModel?.supportsImages ?? false)
            .preferredColorScheme(colorScheme.toiOSFormat)
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
