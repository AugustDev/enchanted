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
                Group {
                    ChatMessageView(avatarName: "AM", name: "You", text: messages[index].prompt, conversationState: nil)
                    ChatMessageView(avatarName: "AI", name: "AI", text: messages[index].response ?? "", conversationState: index + 1 == messages.count ? conversationState : nil)
                        .id(messages[index])
                }
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
            .onChange(of: messages.last?.response) {
                scrollToBottom(scrollViewProxy)
            }
            .listStyle(.inset)
            .scrollIndicators(.never)

        }
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
