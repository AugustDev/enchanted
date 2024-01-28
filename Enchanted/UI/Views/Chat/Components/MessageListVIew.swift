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
    @Binding var editMessage: MessageSD?
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            List(messages, id:\.self) { message in
                let roleName = message.role == "user" ? "AM" : "AI"
                let uiImage: UIImage? = message.image != nil ? UIImage(data: message.image!) : nil
                let userContextMenu = ContextMenu(menuItems: {
                    Button(action: {  }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    
                    if message.role == "user" {
                        Button(action: {
                            withAnimation { editMessage = message }
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                    
                    if editMessage?.id == message.id {
                        Button(action: {
                            withAnimation { editMessage = nil }
                        }) {
                            Label("Unselect", systemImage: "pencil")
                        }
                    }
                })
                ChatMessageView(avatarName: roleName, name: message.role, text: message.content, uiImage: uiImage)
                    .id(message.id)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 10)
                    .contextMenu(userContextMenu)
                    .padding(.horizontal, 10)
                    .runningBorder(animated: message.id == editMessage?.id)
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
    MessageListView(
        messages: MessageSD.sample,
        conversationState: .loading,
        editMessage: .constant(MessageSD.sample[0])
    )
}
