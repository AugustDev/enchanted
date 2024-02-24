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
    @State private var retrievalStore = RetrievalStore.shared
    @State private var appStore = AppStore.shared
    
    var body: some View {
        Chat(languageModelStore: languageModelStore, conversationStore: conversationStore, appStore: appStore)
            .task {
                Task.detached {
                    async let loadModels: () = languageModelStore.loadModels()
                    async let loadConversations: () = conversationStore.loadConversations()
                    async let loadRetrieval: () = () = retrievalStore.getDatabases()
                    
                    do {
                        _ = try await loadModels
                        _ = try await loadConversations
                        _ = try await loadRetrieval
                    } catch {
                        print("Unexpected error: \(error).")
                    }
                }
            }
            .preferredColorScheme(colorScheme.toiOSFormat)
    }
}

