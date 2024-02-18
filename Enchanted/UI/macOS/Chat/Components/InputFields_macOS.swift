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
    @Binding var editMessage: MessageSD?
    
    @State private var selectedImage: Image?
    @State private var fileDropActive: Bool = false
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
        HStack(spacing: 20) {
            if let image = selectedImage {
                RemovableImage(
                    image: image,
                    onClick: {selectedImage = nil},
                    height: 70
                )
                .padding(5)
            }
            
            TextField("Message", text: $message, axis: .vertical)
                .focused($isFocusedInput)
                .frame(minHeight: 40)
                .font(.system(size: 14))
                .textFieldStyle(.plain)
                .onSubmit {
                    if NSApp.currentEvent?.modifierFlags.contains(.shift) == true {
                        message += "\n"
                    } else {
                        sendMessage()
                    }
                }
            /// TextField bypasses drop area
                .allowsHitTesting(!fileDropActive)
            
            SimpleFloatingButton(systemImage: "photo.fill", onClick: {})
            
            switch conversationState {
            case .loading:
                SimpleFloatingButton(systemImage: "square.fill", onClick: onStopGenerateTap)
            default:
                SimpleFloatingButton(
                    systemImage: "paperplane.fill",
                    onClick: { Task { sendMessage() } }
                )
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
        .overlay {
            if fileDropActive {
                DragAndDrop(cornerRadius: 10)
            }
        }
        .animation(.default, value: fileDropActive)
        .onDrop(of: [.image], isTargeted: $fileDropActive.animation(), perform: { providers in
            guard let provider = providers.first else { return false }
            _ = provider.loadDataRepresentation(for: .image) { data, error in
                if error == nil, let data {
                    if let nsImage = NSImage(data: data) {
                        selectedImage = Image(nsImage: nsImage)
                    }
                }
            }
            
            return true
        })
    }
}

#Preview {
    InputFieldsView(
        message: .constant(""),
        conversationState: .completed,
        onStopGenerateTap: {},
        onSendMessageTap: {_, _, _, _  in},
        editMessage: .constant(nil)
    )
}
#endif
