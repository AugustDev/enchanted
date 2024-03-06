//
//  PanelCompletionsView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 29/02/2024.
//

#if os(macOS)
import SwiftUI
import Magnet

struct PanelCompletionsView: View {
    var completions: [CompletionInstructionSD]
    var onClick: @MainActor (_ completion: CompletionInstructionSD, _ scheduledTyping: Bool) -> ()
    @State var scheduledTyping = false
    @State var selectedCompletion: CompletionInstructionSD? = nil
    
    var filetedCompletions: [CompletionInstructionSD] {
        if let selectedCompletion = selectedCompletion {
            return [selectedCompletion]
        }
        return completions
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Image("logo-nobg")
                    .resizable()
                    .antialiased(true)
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.label)
                
                Text("Completions")
                    .font(.title2)
                    .fontWeight(.light)
                    .enchantify()
                
                Spacer()
                
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: "space")
                    Text("Mode")
                }
                .padding(.horizontal, 8)
                .showIf(scheduledTyping)
                .showIf(selectedCompletion == nil)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("Tap")
                    Image(systemName: "space")
                    Text("to begin")
                }
                .showIf(selectedCompletion != nil)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(filetedCompletions) { completion in
                        CompletionButtonView(
                            name: completion.name,
                            keyboardCharacter: completion.keyboardCharacter,
                            action: {
                                withAnimation {
                                    selectedCompletion = completion
                                    onClick(completion, scheduledTyping)
                                }
                            }
                        )
                        .keyboardShortcut(KeyEquivalent(completion.keyboardCharacter), modifiers: [])
                    }
                }
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
        }
        .onKeyboardShortcut(key: .space, modifiers: []) {
            withAnimation {
                scheduledTyping.toggle()
            }
        }
        .frame(minWidth: 500, maxWidth: 500)
    }
}

#Preview {
    PanelCompletionsView(
        completions: CompletionInstructionSD.samples,
        onClick: {_,_  in}
    )
}
#endif
