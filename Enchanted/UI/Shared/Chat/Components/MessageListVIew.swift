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
    @Binding var editMessage: MessageSD?
    
    func onEditMessageTap() -> (MessageSD) -> Void {
        return { message in
            editMessage = message
        }
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(messages, id:\.self) { message in
                        let userContextMenu = ContextMenu(menuItems: {
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
                        ChatMessageView(
                            message: message,
                            editMessage: $editMessage
                        )
                        .simultaneousGesture(DragGesture().onChanged { _ in })
                        .id(message.id)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 10)
                        .contextMenu(userContextMenu)
                        .padding(.horizontal, 10)
                        .runningBorder(animated: message.id == editMessage?.id)
                    }
                    .scrollContentBackground(.hidden)
                    .onAppear {
                        scrollToBottom(scrollViewProxy)
                    }
                    .onChange(of: messages) {
                        scrollToBottom(scrollViewProxy)
                    }
                    .onChange(of: messages.last?.content) {
                        scrollToBottom(scrollViewProxy)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard messages.count > 0 else { return }
        proxy.scrollTo(messages[messages.endIndex - 1].id, anchor: .bottom)
    }
}

#Preview {
    MessageListView(
        messages: MessageSD.sample,
        conversationState: .loading,
        editMessage: .constant(MessageSD.sample[0])
    )
}
