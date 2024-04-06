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
    @State var completionsStore = CompletionsStore.shared
    @State var appStore = AppStore.shared
    @State var completionsPanelVM: CompletionsPanelVM
    var onSubmitPanel: () -> ()
    var onSubmitCompletion: (_ scheduledTyping: Bool) -> ()
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
    
    @MainActor
    func completionInWindow(_ completion: CompletionInstructionSD, scheduledTyping: Bool) {
        guard let selectedModel = languageModelStore.selectedModel else { return }
        completionsPanelVM.sendPrompt(completion: completion, model: selectedModel)
        onSubmitCompletion(scheduledTyping)
        appStore.uiLog(message: "In Window Completion - **\(completion.name)**", status: .info)
    }
    
    @MainActor
    func completionInApp(_ completion: CompletionInstructionSD) {
        guard languageModelStore.selectedModel != nil else { return }
        let prompt = CompletionsPanelVM.constructPrompt(completion: completion, selectedText: completionsPanelVM.selectedText ?? "")
        sendMessage(prompt: prompt, image: nil)
        appStore.uiLog(message: "In App Completion - **\(completion.name)**", status: .info)
    }
    
    var body: some View {
        Group {
            if let selectedText = completionsPanelVM.selectedText, !selectedText.isEmpty {
                PanelCompletionsView(
                    completions: completionsStore.completions,
                    completionInWindow: completionInWindow,
                    completionInApp: completionInApp
                )
            } else {
                PromptPanelView(
                    onSubmit: sendMessage,
                    onLayoutUpdate: onLayoutUpdate,
                    imageSupport: languageModelStore.selectedModel?.supportsImages ?? false
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
#endif
