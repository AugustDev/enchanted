//
//  Settings.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 28/12/2023.
//

import SwiftUI

struct Settings: View {
    @Environment(LanguageModelStore.self) private var languageModelStore
    @AppStorage("ollamaUri") private var ollamaUri: String = ""
    @AppStorage("systemPrompt") private var systemPrompt: String = ""
    @AppStorage("vibrations") private var vibrations: Bool = true
    @AppStorage("colorScheme") private var colorScheme = AppColorScheme.system
    @Environment(\.presentationMode) var presentationMode
    
    private func save() {
        Haptics.shared.play(.medium)
        // remove trailing slash
        if ollamaUri.last == "/" {
            ollamaUri = String(ollamaUri.dropLast())
        }
        
        OllamaService.reinit(url: ollamaUri)
        Task {
            presentationMode.wrappedValue.dismiss()
            try? await languageModelStore.loadModels()
        }
    }
    
    private func checkServer() {
        Task {
            OllamaService.reinit(url: ollamaUri)
            ollamaStatus = await OllamaService.shared.reachable()
            try? await languageModelStore.loadModels()
        }
    }
    
    @State var ollamaStatus: Bool?
    var body: some View {
        SettingsView(
            ollamaUri: $ollamaUri,
            systemPrompt: $systemPrompt, 
            vibrations: $vibrations,
            colorScheme: $colorScheme,
            save: save,
            checkServer: checkServer
        )
    }
}

#Preview {
    Settings()
}
