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
#if os(macOS)
    @NSApplicationDelegateAdaptor(PanelManager.self) var panelManager
#endif
    
    var body: some Scene {
        WindowGroup {
            ApplicationEntry()
                .task {
#if os(macOS)
                    HotkeyService.shared.register(callback: {panelManager.togglePanel()})
#endif
                }
        }
        
#if os(macOS)
#if false
        MenuBarExtra {
            MenuBarControl()
        } label: {
            MenuBarControlView.icon
        }
        .menuBarExtraStyle(.window)
#endif
#endif
    }
}

