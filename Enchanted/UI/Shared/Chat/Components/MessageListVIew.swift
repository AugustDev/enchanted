//
//  MessageListVIew.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import SwiftUI

#if os(macOS)
import AppKit
#endif

struct MessageListView: View {
    var messages: [MessageSD]
    var conversationState: ConversationState
    var userInitials: String
    @Binding var editMessage: MessageSD?
    
    func onEditMessageTap() -> (MessageSD) -> Void {
        return { message in
            editMessage = message
        }
    }
    
    func createUserContextMenu(_ message: MessageSD) -> ContextMenu<TupleView<(Button<Label<Text, Image>>, Button<Label<Text, Image>>?, Button<Label<Text, Image>>?)>> {
        ContextMenu(menuItems: {
            Button(action: {Clipboard.shared.setString(message.content)}) {
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
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                ForEach(messages) { message in
                    ChatMessageView(
                        message: message,
                        showLoader: conversationState == .loading && messages.last == message,
                        userInitials: userInitials,
                        editMessage: $editMessage
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 10)
                    .contextMenu(createUserContextMenu(message))
                    .padding(.horizontal, 10)
                    .runningBorder(animated: message.id == editMessage?.id)
                    .id(message)
                }
            }
            .textSelection(.enabled)
            .onAppear {
                scrollViewProxy.scrollTo(messages.last, anchor: .bottom)
            }
            .onChange(of: messages) { oldMessages, newMessages in
                scrollViewProxy.scrollTo(messages.last, anchor: .bottom)
            }
            .onChange(of: messages.last?.content) {
                scrollViewProxy.scrollTo(messages.last, anchor: .bottom)
            }
        }
    }
}

#Preview {
    MessageListView(
        messages: MessageSD.sample,
        conversationState: .loading,
        userInitials: "AM",
        editMessage: .constant(MessageSD.sample[0])
    )
}
