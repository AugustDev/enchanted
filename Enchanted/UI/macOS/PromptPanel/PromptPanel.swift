//
//  PromptPanel.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

import SwiftUI

struct PromptPanel: View {
    @State var conversationStore: ConversationStore
    
    var body: some View {
        PromptPanelView()
            .onAppear {
                print(conversationStore.conversations)
            }
    }
}
