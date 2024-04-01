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
    @State private var appStore = AppStore.shared
#if os(macOS)
    @NSApplicationDelegateAdaptor(PanelManager.self) var panelManager
#endif
    
    var body: some Scene {
        WindowGroup {
            ApplicationEntry()
                .task(priority: .background) {
#if os(macOS)
                    HotkeyService.shared.register(callback: {panelManager.togglePanel()})
#endif
                }
#if os(macOS)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
#endif
        }
#if os(macOS)
        Window("Keyboard Shortcuts", id: "keyboard-shortcuts") {
            KeyboardShortcuts()
        }
#endif
        
#if os(macOS)
#if false
        MenuBarExtra {
            MenuBarControl()
        } label: {
            if let iconName = appStore.menuBarIcon {
                Image(systemName: iconName)
            } else {
                MenuBarControlView.icon
            }
        }
        .menuBarExtraStyle(.window)
#endif
#endif
    }
}

