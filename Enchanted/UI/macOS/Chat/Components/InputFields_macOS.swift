//
//  InputFields_macOS.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

#if os(macOS)
import SwiftUI

struct InputFieldsView: View {
    @Binding var message: String
    var conversationState: ConversationState
    var onStopGenerateTap: @MainActor () -> Void
    var selectedModel: LanguageModelSD?
    var onSendMessageTap: @MainActor (_ prompt: String, _ model: LanguageModelSD, _ image: Image?, _ trimmingMessageId: String?) -> ()
    
    @State private var selectedImage: Image?
    @State private var editMessage: MessageSD?
    @FocusState private var isFocusedInput: Bool
    
    @MainActor private func sendMessage() {
        guard let selectedModel = selectedModel else { return }
        
        onSendMessageTap(
            message,
            selectedModel,
            selectedImage,
            editMessage?.id.uuidString
        )
        withAnimation {
            isFocusedInput = false
            editMessage = nil
            selectedImage = nil
            message = ""
        }
    }
    
    var body: some View {
        HStack {
            TextField("Message", text: $message, axis: .vertical)
                .focused($isFocusedInput)
                .frame(minHeight: 40)
                .font(.system(size: 14))
                .textFieldStyle(.plain)
                .onSubmit {
                    sendMessage()
                }
            
            ZStack {
                Circle()
                    .foregroundColor(Color.labelCustom)
                    .frame(width: 30, height: 30)
                
                switch conversationState {
                case .loading:
                    Button(action: onStopGenerateTap) {
                        Image(systemName: "square.fill")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.bgCustom)
                            .frame(height: 12)
                    }
                    .buttonStyle(.plain)
                default:
                    Button(action: {
                        Task {
                            sendMessage()
                        }
                    }) {
                        Image(systemName: "arrow.up")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.bgCustom)
                            .frame(height: 15)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    Color.gray2Custom,
                    style: StrokeStyle(lineWidth: 1)
                )
        )
    }
}

#Preview {
    InputFieldsView(
        message: .constant(""),
        conversationState: .completed,
        onStopGenerateTap: {},
        onSendMessageTap: {_, _, _, _  in}
    )
}
#endif
