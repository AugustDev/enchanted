//
//  ChatView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI
import Speech

struct ChatView: View {
    var conversation: ConversationSD?
    var messages: [MessageSD]
    var modelsList: [LanguageModelSD]
    var onMenuTap: () -> ()
    var onNewConversationTap: () -> ()
    var onSendMessageTap: @MainActor (_ prompt: String, _ model: LanguageModelSD) -> ()
    var conversationState: ConversationState
    var onStopGenerateTap: () -> ()
    var reachable: Bool
    
    @State private var selectedModel: LanguageModelSD?
    @State private var message = ""
    @State private var isRecording = false
    @FocusState private var isFocusedInput: Bool
    
    init(
        conversation: ConversationSD? = nil,
        messages: [MessageSD],
        modelsList: [LanguageModelSD],
        selectedModel: LanguageModelSD?,
        onMenuTap: @escaping () -> Void,
        onNewConversationTap: @escaping () -> Void,
        onSendMessageTap: @MainActor @escaping (_ prompt: String, _ model: LanguageModelSD) -> Void,
        conversationState: ConversationState,
        onStopGenerateTap:  @escaping () -> Void,
        reachable: Bool
    ) {
        self.conversation = conversation
        self.messages = messages
        self.modelsList = modelsList
        self.onMenuTap = onMenuTap
        self.onNewConversationTap = onNewConversationTap
        self.onSendMessageTap = onSendMessageTap
        self.conversationState = conversationState
        self.onStopGenerateTap = onStopGenerateTap
        self.reachable = reachable
        self.selectedModel = selectedModel
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
            HStack {
                TextField("Message", text: $message, axis: .vertical)
                    .focused($isFocusedInput)
                    .frame(minHeight: 40)
                    .font(.system(size: 14))
                
                RecordingView(isRecording: $isRecording.animation()) { transcription in
                    self.message = transcription
                }
            }
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        isRecording ? Color(.systemBlue) : Color(.systemGray2),
                        style: StrokeStyle(lineWidth: isRecording ? 2 : 0.5)
                    )
            )
            
            ZStack {
                Circle()
                    .foregroundColor(Color(.label))
                    .frame(width: 30, height: 30)
                
                switch conversationState {
                case .loading:
                    Button(action: onStopGenerateTap) {
                        Image(systemName: "square.fill")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(.systemBackground))
                            .frame(height: 12)
                    }
                default:
                    Button(action: {
                        Task {
                            guard let selectedModel = selectedModel else { return }
                            isFocusedInput = false
                            await onSendMessageTap(message, selectedModel)
                            message = ""
                        }
                    }) {
                        Image(systemName: "arrow.up")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(.systemBackground))
                            .frame(height: 15)
                    }
                }
            }
        }
    }
    
    var unreachableApi: some View {
        HStack {
            Text("Ollama is unreachable. Go to Settings and update your Ollama API endpoint.")
                .fontWeight(.medium)
                .font(.system(size: 14))
            Spacer()
        }
        .padding()
        .background(Color(.systemRed).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @State private var animationAmount: CGFloat = 1
    
    
    var body: some View {
        VStack {
            header
            
            if conversation != nil {
                MessageListView(messages: messages, conversationState: conversationState)
            } else {
                Spacer()
                
                VStack(spacing: 25) {
                    Image("logo-nobg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .scaleEffect(animationAmount)
                        .animation(
                            .snappy(duration: 0.6, extraBounce: 0.3)
                            .delay(5)
                            .repeatForever(autoreverses: true),
                            value: animationAmount)
                        .onAppear {
                            animationAmount = 1.3
                        }
                    
                    Text("Start new conversation")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(.systemGray))
                }
                Spacer()
            }
            
            ConversationStatusView(state: conversationState)
                .padding()
            
            if !reachable {
                unreachableApi
            }
            
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
        selectedModel: LanguageModelSD.sample[0],
        onMenuTap: {},
        onNewConversationTap: { },
        onSendMessageTap: {_,_  in},
        conversationState: .loading,
        onStopGenerateTap: {},
        reachable: false
    )
}

#Preview {
    ChatView(
        conversation: nil,
        messages: [],
        modelsList: LanguageModelSD.sample,
        selectedModel: LanguageModelSD.sample[0],
        onMenuTap: {},
        onNewConversationTap: { },
        onSendMessageTap: {_,_  in},
        conversationState: .completed,
        onStopGenerateTap: {},
        reachable: true
    )
}
