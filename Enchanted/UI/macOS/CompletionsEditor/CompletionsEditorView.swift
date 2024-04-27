//
//  CompletionsEditorView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 29/02/2024.
//

#if os(macOS)
import SwiftUI
import KeyboardShortcuts

struct CompletionsEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var completions: [CompletionInstructionSD]
    @State var selectedCompletion: CompletionInstructionSD?
    var onSave: () -> ()
    var onDelete: (CompletionInstructionSD) -> ()
    var accessibilityAccess: Bool
    var requestAccessibilityAccess: () -> ()
    
    private func close() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func newCompletion() {
        let newCompletion = CompletionInstructionSD(
            name: "New Completion",
            keyboardCharacterStr: "x",
            instruction: "",
            order: completions.count,
            modelTemperature: 0.8
        )
        withAnimation {
            completions.append(newCompletion)
            selectedCompletion = newCompletion
        }
    }
    
    private func discard(for completion: CompletionInstructionSD) {
        selectedCompletion = nil
        withAnimation {
            completions = completions.filter{$0.id != completion.id}
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Completions")
                    .font(.title)
                    .fontWeight(.thin)
                    .enchantify()
                    .padding(.bottom, 30)
                
                Spacer()
                
                Button(action: close) {
                    Text("Close")
                }
                .buttonStyle(GrowingButton())
            }
            
            Text("Create your own dynamic prompts usable anywhere on your mac with keyboard shortcuts to speed up common tasks. You can reorder, delete and edit your completions.")
                .padding(.bottom, 10)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(alignment: .center) {
                KeyboardShortcuts.Recorder("Keyboard shortcut", name: .togglePanelMode)
                Spacer()
                Button(action: newCompletion) {
                    Text("New Completion")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(GrowingButton())
            }
            .padding(.bottom, 10)
            
            List {
                ForEach($completions, editActions: .move) { $completion in
                    HStack(alignment: .center) {
                        CompletionButtonView(name: completion.name, keyboardCharacter: completion.keyboardCharacter, action: {})
                        
                        Spacer()
                        
                        Text(completion.instruction)
                            .lineLimit(1)
                            .frame(width: 500, alignment: .leading)
                        
                        Button(action: {
                            selectedCompletion = completion
                        }) {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(GrowingButton())
                        
                        Button(action: {onDelete(completion)}) {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(GrowingButton())
                    }
                }
                .onMove { source , destination in
                    completions.move(fromOffsets: source, toOffset: destination)
                    onSave()
                }
            }
            .listStyle(PlainListStyle())
            
            HStack {
                Text("Completions require Accessibility access to capture selected text outside Enchanted.")
                
                Spacer()
                
                Button(action: requestAccessibilityAccess) {
                    Text("Open Privacy Settings")
                }
            }
            .padding()
            .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.red, lineWidth: 1)
                )
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.red.opacity(0.05)))
            .showIf(!accessibilityAccess)
        }
        .padding()
        .frame(width: 800, height: 600)
        .sheet(item: $selectedCompletion) { selectedCompletion in
            UpsertCompletionView(completion: selectedCompletion, onSave: onSave)
                .onDisappear {
                    if selectedCompletion.name == "New Completion" {
                        discard(for: selectedCompletion)
                    }
                }
        }
    }
}

#Preview {
    CompletionsEditorView(completions: .constant(CompletionInstructionSD.samples), onSave: {}, onDelete: {_ in }, accessibilityAccess: false, requestAccessibilityAccess: {})
}
#endif
