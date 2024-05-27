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
    @StateObject private var speechSynthesizer = SpeechSynthesizer.shared
    
    func onEditMessageTap() -> (MessageSD) -> Void {
        return { message in
            editMessage = message
        }
    }
    
    func onReadAloud(_ message: String) {
        Task {
            await speechSynthesizer.speak(text: message)
        }
    }
    
    func stopReadingAloud() {
        Task {
            await speechSynthesizer.stopSpeaking()
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ReadingAloudView(onStopTap: stopReadingAloud)
                .showIf(speechSynthesizer.isSpeaking)
            
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(messages) { message in
                        
                        let contextMenu = ContextMenu(menuItems: {
                            Button(action: {Clipboard.shared.setString(message.content)}) {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            
#if os(iOS) || os(visionOS)
                            Button(action: { messageSelected = message }) {
                                Label("Select Text", systemImage: "selection.pin.in.out")
                            }
                            
                            Button(action: {
                                onReadAloud(message.content)
                            }) {
                                Label("Read Aloud", systemImage: "speaker.wave.3.fill")
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
}

#Preview {
    MessageListView(
        messages: MessageSD.sample,
        conversationState: .loading,
        userInitials: "AM",
        editMessage: .constant(MessageSD.sample[0])
    )
}
