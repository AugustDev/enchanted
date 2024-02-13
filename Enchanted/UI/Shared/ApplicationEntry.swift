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
    @State private var appStore = AppStore.shared

    var body: some View {
        Chat(languageModelStore: languageModelStore, conversationStore: conversationStore, appStore: appStore)
            .task {
                if let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
                    print("CFBundleVersion: \(build)")
                }
                if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                    print("CFBundleShortVersionString: \(version)")
                }
                Task.detached {
                    async let loadModels: () = languageModelStore.loadModels()
                    async let loadConversations: () = conversationStore.loadConversations()
                    
                    do {
                        _ = try await loadModels
                        _ = try await loadConversations
                    } catch {
                        print("Unexpected error: \(error).")
                    }
                }
            }
            .preferredColorScheme(colorScheme.toiOSFormat)
    }
}

