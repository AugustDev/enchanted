//
//  ApplicationEntry.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

import SwiftUI
import SwiftData

struct ApplicationEntry: View {
    @AppStorage("colorScheme") private var colorScheme: AppColorScheme = .system
    @State private var languageModelStore = LanguageModelStore.shared
    @State private var conversationStore = ConversationStore.shared
    @State private var completionsStore = CompletionsStore.shared
    @State private var appStore = AppStore.shared
    
    var body: some View {
        VStack {
            switch appStore.appState {
            case .chat:
                Chat(languageModelStore: languageModelStore, conversationStore: conversationStore, appStore: appStore)
            case .voice:
                Voice(languageModelStore: languageModelStore, conversationStore: conversationStore, appStore: appStore)
            }
        }
        .task {
            
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                print("Bundle Identifier: \(bundleIdentifier)")
            } else {
                print("Bundle Identifier not found.")
            }
            
            Task.detached {
                async let loadModels: () = languageModelStore.loadModels()
                async let loadConversations: () = conversationStore.loadConversations()
                async let loadCompletions: () = completionsStore.load()
                
                do {
                    _ = try await loadModels
                    _ = try await loadConversations
                    _ = try await loadCompletions
                } catch {
                    print("Unexpected error: \(error).")
                }
            }
        }
        .preferredColorScheme(colorScheme.toiOSFormat)
    }
}

