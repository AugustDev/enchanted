//
//  EnchantedApp.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI
import SwiftData

@main
struct EnchantedApp: App {
    @AppStorage("colorScheme") private var colorScheme: AppColorScheme = .system
    @State private var languageModelStore: LanguageModelStore
    @State private var conversationStore: ConversationStore
    @State private var appStore: AppStore
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LanguageModelSD.self,
            ConversationSD.self,
            MessageSD.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        let swiftDataService = SwiftDataService(modelContext: sharedModelContainer.mainContext)
        languageModelStore = LanguageModelStore(swiftDataService: swiftDataService)
        conversationStore = ConversationStore(swiftDataService: swiftDataService)
        appStore = AppStore()
    }
    
    var body: some Scene {
        WindowGroup {
            Chat()
                .environment(languageModelStore)
                .environment(conversationStore)
                .environment(appStore)
                .task {
                    try? await languageModelStore.loadModels()
                    try? await conversationStore.loadConversations()
                }
                .preferredColorScheme(colorScheme.toiOSFormat)
        }
        .modelContainer(sharedModelContainer)
    }
}
