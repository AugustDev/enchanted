//
//  ChatView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI

struct ChatView: View {
    var conversation: ConversationSD?
    var messages: [MessageSD]
    var modelsList: [LanguageModelSD]
    var onMenuTap: () -> ()
    var onNewConversationTap: () -> ()
    var onSendMessageTap: (_ prompt: String, _ model: LanguageModelSD) -> ()
    var conversationState: ConversationState
    var onStopGenerateTap: () -> ()
    var reachable = false
    
    @State private var selectedModel: LanguageModelSD?
    @State private var message = ""
    
    init(
        conversation: ConversationSD? = nil,
        messages: [MessageSD],
        modelsList: [LanguageModelSD],
        onMenuTap: @escaping () -> Void,
        onNewConversationTap: @escaping () -> Void,
        onSendMessageTap: @escaping (_ prompt: String, _ model: LanguageModelSD) -> Void,
        conversationState: ConversationState,
        onStopGenerateTap: @escaping () -> Void
    ) {
        self.conversation = conversation
        self.messages = messages
        self.modelsList = modelsList
        self.onMenuTap = onMenuTap
        self.onNewConversationTap = onNewConversationTap
        self.onSendMessageTap = onSendMessageTap
        self.conversationState = conversationState
        self.onStopGenerateTap = onStopGenerateTap
        
        if let model = conversation?.model {
            self._selectedModel = State(initialValue: model)
        } else if modelsList.count > 0 {
            self._selectedModel = State(initialValue: modelsList.first)
        }
    }
    
    var header: some View {
        HStack(alignment: .center) {
            Button(action: onMenuTap) {
                Image(systemName: "line.3.horizontal")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .foregroundColor(Color(.label))
            }
            
            Spacer()
            
            if modelsList.count > 0 {
                ModelSelector(modelsList: modelsList, selectedModel: $selectedModel)
            }
            
            Spacer()
            
            Button(action: onNewConversationTap) {
                Image(systemName: "square.and.pencil")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .foregroundColor(Color(.label))
            }
            
        }
    }
    
    var inputFields: some View {
        HStack(spacing: 10) {
            TextField("Message", text: $message, axis: .vertical)
                .font(.system(size: 14))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color(.systemGray2), style: StrokeStyle(lineWidth: 0.5)))
            
            ZStack {
                Circle()
                    .foregroundColor(Color(.label))
                    .frame(width: 24, height: 24)
                
                switch conversationState {
                case .loading:
                    Button(action: onStopGenerateTap) {
                        Image(systemName: "square.fill")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(.systemBackground))
                            .frame(height: 9)
                    }
                default:
                    Button(action: {
                        guard let selectedModel = selectedModel else { return }
                        onSendMessageTap(message, selectedModel)
                        message = ""
                    }) {
                        Image(systemName: "arrow.up")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(.systemBackground))
                            .frame(height: 13)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            header
            
            if conversation != nil {
                MessageListView(messages: messages, conversationState: conversationState)
            } else {
                Spacer()
                Text("Start new conversation")
                Spacer()
            }
             
            ConversationStatusView(state: conversationState)
                .padding()
            
            inputFields
            
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .onChange(of: modelsList, { _, modelsList in
            if selectedModel == nil {
                selectedModel = modelsList.first
            }
        })
        .onChange(of: conversation, initial: true, { _, newConversation in
            if let conversation = newConversation {
                selectedModel = conversation.model
            } else {
                selectedModel = modelsList.first
            }
        })
    }
}

#Preview {
    ChatView(
        conversation: ConversationSD.sample[0],
        messages: MessageSD.sample,
        modelsList: LanguageModelSD.sample,
        onMenuTap: {},
        onNewConversationTap: { },
        onSendMessageTap: {_,_  in},
        conversationState: .loading,
        onStopGenerateTap: {}
    )
}
