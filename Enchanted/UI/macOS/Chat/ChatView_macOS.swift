//
//  Chat.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

#if os(macOS)
import SwiftUI

struct ChatView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    var selectedConversation: ConversationSD?
    var conversations: [ConversationSD]
    var messages: [MessageSD]
    var modelsList: [LanguageModelSD]
    var onMenuTap: () -> ()
    var onNewConversationTap: () -> ()
    var onSendMessageTap: @MainActor (_ prompt: String, _ model: LanguageModelSD, _ image: Image?, _ trimmingMessageId: String?) -> ()
    var onConversationTap: (_ conversation: ConversationSD) -> ()
    var conversationState: ConversationState
    var onStopGenerateTap: @MainActor () -> ()
    var reachable: Bool
    var modelSupportsImages: Bool
    var selectedModel: LanguageModelSD?
    var onSelectModel: @MainActor (_ model: LanguageModelSD?) -> ()
    var onConversationDelete: (_ conversation: ConversationSD) -> ()
    var onDeleteDailyConversations: (_ date: Date) -> ()
    
    @State private var message = ""
    @State private var editMessage: MessageSD?
    @FocusState private var isFocusedInput: Bool
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(
                conversations: conversations,
                onConversationTap: onConversationTap,
                onConversationDelete: onConversationDelete,
                onDeleteDailyConversations: onDeleteDailyConversations
            )
        } detail: {
            VStack(alignment: .center) {
                if selectedConversation != nil {
                    MessageListView(
                        messages: messages,
                        conversationState: conversationState,
                        editMessage: $editMessage
                    )
                } else {
                    EmptyConversaitonView(sendPrompt: {selectedMessage in
                        if let selectedModel = selectedModel {
                            onSendMessageTap(selectedMessage, selectedModel, nil, nil)
                        }
                    })
                }
                
                if !reachable {
                    UnreachableAPIView()
                }
                
                InputFieldsView(
                    message: $message,
                    conversationState: conversationState,
                    onStopGenerateTap: onStopGenerateTap,
                    selectedModel: selectedModel,
                    onSendMessageTap: onSendMessageTap, 
                    editMessage: $editMessage
                )
                .padding()
                .frame(maxWidth: 800)
            }
        }
        .toolbar {
            ToolbarView(
                modelsList: modelsList,
                selectedModel: selectedModel,
                onSelectModel: onSelectModel,
                onNewConversationTap: onNewConversationTap
            )
        }
        .onChange(of: editMessage, initial: false) { _, newMessage in
            if let newMessage = newMessage {
                message = newMessage.content
                isFocusedInput = true
            }
        }
    }
}

#Preview {
    ChatView(
        selectedConversation: ConversationSD.sample[0],
        conversations: ConversationSD.sample,
        messages: MessageSD.sample,
        modelsList: LanguageModelSD.sample,
        onMenuTap: {},
        onNewConversationTap: { },
        onSendMessageTap: {_,_,_,_    in},
        onConversationTap: {_ in},
        conversationState: .completed,
        onStopGenerateTap: {},
        reachable: true,
        modelSupportsImages: true,
        selectedModel: LanguageModelSD.sample[0], onSelectModel: {_ in},
        onConversationDelete: {_ in},
        onDeleteDailyConversations: {_ in}
    )
}
#endif
