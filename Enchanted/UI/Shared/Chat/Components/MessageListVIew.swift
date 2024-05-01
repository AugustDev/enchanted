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
    @State private var messageSelected: MessageSD?
    
    func onEditMessageTap() -> (MessageSD) -> Void {
        return { message in
            editMessage = message
        }
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                ForEach(messages) { message in
                    
                    let contextMenu = ContextMenu(menuItems: {
                        Button(action: {Clipboard.shared.setString(message.content)}) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                        
#if os(iOS)
                        Button(action: { messageSelected = message }) {
                            Label("Select Text", systemImage: "selection.pin.in.out")
                        }
#endif
                        
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
                    
                    ChatMessageView(
                        message: message,
                        showLoader: conversationState == .loading && messages.last == message,
                        userInitials: userInitials,
                        editMessage: $editMessage
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 10)
                    .contextMenu(contextMenu)
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
#if os(iOS)
            .sheet(item: $messageSelected) { message in
                SelectTextSheet(message: message)
            }
#endif
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
