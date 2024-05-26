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
    @State var isRecording = false
    
    @State private var selectedImage: Image?
    @State private var fileDropActive: Bool = false
    @State private var fileSelectingActive: Bool = false
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
            isRecording = false
            isFocusedInput = false
            editMessage = nil
            selectedImage = nil
            message = ""
        }
    }
    
    private func updateSelectedImage(_ image: Image) {
        selectedImage = image
    }
    
    var hotkeys: [HotkeyCombination] {
        [
            HotkeyCombination(keyBase: [.command], key: .kVK_ANSI_V) {
                if let nsImage = Clipboard.shared.getImage() {
                    let image = Image(nsImage: nsImage)
                    updateSelectedImage(image)
                }
            }
        ]
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
            
            TextField("Message", text: $message.animation(.easeOut(duration: 0.3)), axis: .vertical)
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
                .addCustomHotkeys(hotkeys)
            
            RecordingView(isRecording: $isRecording.animation()) { transcription in
                withAnimation(.easeIn(duration: 0.3)) {
                    self.message = transcription
                }
            }
            
            SimpleFloatingButton(systemImage: "photo.fill", onClick: { fileSelectingActive.toggle() })
                .showIf(selectedModel?.supportsImages ?? false)
                .fileImporter(isPresented: $fileSelectingActive,
                              allowedContentTypes: [.png, .jpeg, .tiff],
                              onCompletion: { result in
                    switch result {
                    case .success(let url):
                        guard url.startAccessingSecurityScopedResource() else { return }
                        if let imageData = try? Data(contentsOf: url),
                           let nsImage = NSImage(data: imageData) {
                            selectedImage = Image(nsImage: nsImage)
                        }
                        url.stopAccessingSecurityScopedResource()
                    case .failure(let error):
                        print(error)
                    }
                })
            
            
            switch conversationState {
            case .loading:
                SimpleFloatingButton(systemImage: "square.fill", onClick: onStopGenerateTap)
            default:
                SimpleFloatingButton(systemImage: "paperplane.fill", onClick: { Task { sendMessage() } })
                    .showIf(!message.isEmpty)
            }
        }
        .transition(.slide)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
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
        .contentShape(Rectangle())
        .onTapGesture {
            // allow focusing text area on greater tap area
            isFocusedInput = true
        }
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
