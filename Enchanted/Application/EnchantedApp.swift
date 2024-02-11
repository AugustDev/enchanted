//
//  EnchantedApp.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI
import SwiftData

enum WindowSize {
    static let min = CGSize(width: 1200, height: 800)
    static let ideal = CGSize(width: 1400, height: 1000)
}

@main
struct EnchantedApp: App {
    @AppStorage("colorScheme") private var colorScheme: AppColorScheme = .system
    @State private var languageModelStore: LanguageModelStore
    @State private var conversationStore: ConversationStore
    @State private var appStore: AppStore
//    @State var showingPanel = false
    
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
//                    HotkeyService.shared.register(callback: {showingPanel.toggle()})
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
#if os(macOS)
                .floatingPanel(isPresented: $showingPanel, content: {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                        Text("I'm a floating panel. Click anywhere to dismiss me.")
                    }
                })
//                .frame(minWidth: WindowSize.min.width, idealWidth: WindowSize.ideal.width, minHeight: WindowSize.min.height, idealHeight: WindowSize.ideal.height)
#endif
        }
        .modelContainer(sharedModelContainer)
    }
}
