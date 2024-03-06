//
//  UpsertCompletionView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 01/03/2024.
//

#if os(macOS)
import SwiftUI

//struct XXX: View {
//    var body: some View {
//        LabeledContent("Instruction Prompt") {
//            TextEditor(text: .constant("prompt"))
////                                .scrollContentBackground(.hidden)
//                .padding(4) // Inner padding for text content
//                .frame(height: 50) // Approximate height to match TextField
//                .background(Color.systemBackground) // Use system background color for inner background
//                .cornerRadius(8) // Rounded corners similar to TextField
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray.opacity(0.25), lineWidth: 0.5) // Subtle border matching TextField
//                )
//                .padding()
//        }
//    }
//}

struct UpsertCompletionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var name: String = "New Instruction"
    @State var prompt: String = ""
    @State var keyboardShortcutKey: String = "x"
    @State var delayInput: String = "0"
    
    var existingCompletion: CompletionInstructionSD?
    var onSave: () -> ()
    
    init(completion: CompletionInstructionSD? = nil, onSave: @escaping () -> ()) {
        self.existingCompletion = completion
        self.onSave = onSave
        
        if let completion = completion {
            _name = State(initialValue: completion.name)
            _prompt = State(initialValue: completion.instruction)
            _keyboardShortcutKey = State(initialValue: completion.keyboardCharacter.lowercased())
            _delayInput = State(initialValue: "\(completion.delay)")
        }
    }
    
    private func save() {
        existingCompletion?.name = name
        existingCompletion?.instruction = prompt
        existingCompletion?.keyboardCharacterStr = keyboardShortcutKey
        onSave()
        presentationMode.wrappedValue.dismiss()
    }
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(GrowingButton())
                
                Spacer()
                
                Button(action: save) {
                    Text("Save")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(GrowingButton())
            }
            .padding(.bottom, 20)
            
            Form {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                VStack(alignment: .trailing) {
                        LabeledContent("Instruction Prompt") {
                            TextEditor(text: $prompt)
                                .scrollContentBackground(.hidden)
                                .lineLimit(6)
                                .frame(height: 80)

                        }
                    
                    Text("Instruction Prompt gets appended before the selected text and together sent to the LLM.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .trailing) {
                    TextField("Keyboard Shortcut Letter", text: $keyboardShortcutKey)
                        .onChange(of: keyboardShortcutKey) { newValue in
                            if newValue.count > 1 {
                                keyboardShortcutKey = String(newValue.prefix(1))
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Only single character keyboard shortcuts allowed.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .trailing) {
                    TextField("Delay (seconds)", text: $delayInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Command will be executed with a short delay allowing to activate different parts of the UI.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 20)
            
            CompletionButtonView(name: name, keyboardCharacter: keyboardShortcutKey.first ?? Character("x"), action: {})
        }
        .padding()
        .frame(maxWidth: 600)
    }
}

#Preview {
    UpsertCompletionView(completion: nil, onSave: {})
}

#endif
