//
//  MessageListVIew.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import SwiftUI

struct MessageListView: View {
    var messages: [MessageSD]
    var conversationState: ConversationState
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            List(messages.indices, id:\.self) { index in
                let roleName = messages[index].role == "user" ? "AM" : "AI"
                let uiImage: UIImage? = messages[index].image != nil ? UIImage(data: messages[index].image!) : nil
                ChatMessageView(avatarName: roleName, name: messages[index].role, text: messages[index].content, uiImage: uiImage)
                    .id(messages[index])
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.top, 20)
            }
            .onAppear {
                scrollToBottom(scrollViewProxy)
            }
            .onChange(of: messages) {
                scrollToBottom(scrollViewProxy)
            }
            .onChange(of: messages.last?.content) {
                scrollToBottom(scrollViewProxy)
            }
            .listStyle(.inset)
            .scrollIndicators(.never)
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard messages.count > 0 else { return }
        let lastIndex = messages.count - 1
        let lastMessage = messages[lastIndex]
        proxy.scrollTo(lastMessage, anchor: .bottom)
    }
}

#Preview {
    MessageListView(messages: MessageSD.sample, conversationState: .loading)
}
