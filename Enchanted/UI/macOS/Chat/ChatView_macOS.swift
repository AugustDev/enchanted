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
    var onSelectModel: @MainActor (_ model: LanguageModelSD?) -> ()
    
    private var selectedModel: LanguageModelSD?
    @State private var message = ""
    @State private var editMessage: MessageSD?
    @FocusState private var isFocusedInput: Bool
    
    /// Image selection
//    @State private var avatarItem: PhotosPickerItem?
    
    init(
        selectedConversation: ConversationSD? = nil,
        conversations: [ConversationSD],
        messages: [MessageSD],
        modelsList: [LanguageModelSD],
        selectedModel: LanguageModelSD?,
        onSelectModel: @MainActor @escaping (_ model: LanguageModelSD?) -> (),
        onConversationTap: @escaping (_ conversation: ConversationSD) -> (),
        onMenuTap: @escaping () -> Void,
        onNewConversationTap: @escaping () -> Void,
        onSendMessageTap: @MainActor @escaping (_ prompt: String, _ model: LanguageModelSD, _ image: Image?, _ trimmingMessageId: String?) -> Void,
        conversationState: ConversationState,
        onStopGenerateTap: @MainActor @escaping () -> Void,
        reachable: Bool,
        modelSupportsImages: Bool = false
    ) {
        self.selectedConversation = selectedConversation
        self.conversations = conversations
        self.messages = messages
        self.modelsList = modelsList
        self.onMenuTap = onMenuTap
        self.onNewConversationTap = onNewConversationTap
        self.onSendMessageTap = onSendMessageTap
        self.conversationState = conversationState
        self.onStopGenerateTap = onStopGenerateTap
        self.onConversationTap = onConversationTap
        self.reachable = reachable
        self.modelSupportsImages = modelSupportsImages
        self.onSelectModel = onSelectModel
        self.selectedModel = selectedModel
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(
                conversations: conversations,
                onConversationTap: onConversationTap,
                onConversationDelete: {_ in },
                onDeleteDailyConversations: {_ in}
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
                    EmptyConversaitonView()
                }
                
                if !reachable {
                    UnreachableAPIView()
                }
                
                InputFieldsView(
                    message: $message,
                    conversationState: conversationState,
                    onStopGenerateTap: onStopGenerateTap, 
                    selectedModel: selectedModel,
                    onSendMessageTap: onSendMessageTap
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
    }
}

#Preview {
    ChatView(
        selectedConversation: ConversationSD.sample[0],
        conversations: ConversationSD.sample,
        messages: MessageSD.sample,
        modelsList: LanguageModelSD.sample,
        selectedModel: LanguageModelSD.sample[0],
        onSelectModel: {_ in}, 
        onConversationTap: {_ in},
        onMenuTap: {},
        onNewConversationTap: { },
        onSendMessageTap: {_,_,_,_    in},
        conversationState: .completed,
        onStopGenerateTap: {},
        reachable: true,
        modelSupportsImages: true
    )
}
#endif
