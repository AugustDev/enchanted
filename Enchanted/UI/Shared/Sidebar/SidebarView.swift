//
//  SidebarView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import SwiftUI

struct SidebarView: View {
    @Environment(\.openWindow) var openWindow
    var conversations: [ConversationSD]
    var onConversationTap: (_ conversation: ConversationSD) -> ()
    var onConversationDelete: (_ conversation: ConversationSD) -> ()
    var onDeleteDailyConversations: (_ date: Date) -> ()
    @State var showSettings = false
    
    private func onSettingsTap() {
        showSettings.toggle()
        Haptics.shared.mediumTap()
    }
    
    private func showKeyboardShortcuts() {
        openWindow(id: "keyboard-shortcuts")
    }
    
    var body: some View {
        VStack {
            ScrollView() {
                ConversationHistoryList(
                    conversations: conversations,
                    onTap: onConversationTap,
                    onDelete: onConversationDelete,
                    onDeleteDailyConversations: onDeleteDailyConversations
                )
            }
            .scrollIndicators(.never)
            
            Divider()
            
#if os(macOS)
            SidebarButton(title: "Shortcuts", image: "keyboard.fill", onClick: showKeyboardShortcuts)
#endif
            
            SidebarButton(title: "Settings", image: "gearshape.fill", onClick: onSettingsTap)
            
        }
        .padding()
        .sheet(isPresented: $showSettings) {
            Settings()
        }
    }
}

#Preview {
    SidebarView(conversations: ConversationSD.sample, onConversationTap: {_ in}, onConversationDelete: {_ in}, onDeleteDailyConversations: {_ in})
}
