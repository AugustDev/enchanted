//
//  PanelCompletionsView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 29/02/2024.
//

#if os(macOS)
import SwiftUI
import Magnet
import WrappingHStack

enum CompletionsPromptMode {
    case completionsInCurrentWindow
    case completionsInWindowDelayed
    case completionsInApp
    
    var next: CompletionsPromptMode {
        switch self {
        case .completionsInApp:
            return .completionsInCurrentWindow
        case .completionsInCurrentWindow:
            return .completionsInWindowDelayed
        case .completionsInWindowDelayed:
            return .completionsInApp
        }
    }
}

struct PanelCompletionsView: View {
    var completions: [CompletionInstructionSD]
    var completionInWindow: @MainActor (_ completion: CompletionInstructionSD, _ scheduledTyping: Bool) -> ()
    var completionInApp: @MainActor (_ completion: CompletionInstructionSD) -> ()
    @State var completionMode: CompletionsPromptMode = .completionsInApp
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
                    
                    switch completionMode {
                    case .completionsInApp:
                        Text("Response in App")
                    case .completionsInCurrentWindow:
                        Text("Response in Window")
                    case .completionsInWindowDelayed:
                        Image(systemName: "space")
                        Text("Response in Window")
                    }

                }
                .padding(.horizontal, 8)
                .showIf(selectedCompletion == nil)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("Tap")
                    Image(systemName: "space")
                    Text("to begin")
                }
                .showIf(selectedCompletion != nil)
            }
            WrappingHStack(alignment: .leading) {
                ForEach(filetedCompletions) { completion in
                    CompletionButtonView(
                        name: completion.name,
                        keyboardCharacter: completion.keyboardCharacter,
                        action: {
                            withAnimation {
                                selectedCompletion = completion
                                switch completionMode {
                                case .completionsInCurrentWindow:
                                    completionInWindow(completion, false)
                                case .completionsInWindowDelayed:
                                    completionInWindow(completion, true)
                                case .completionsInApp:
                                    completionInApp(completion)
                                }
                            }
                        }
                    )
                    .keyboardShortcut(KeyEquivalent(completion.keyboardCharacter), modifiers: [])
                }
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
        }
        .onKeyboardShortcut(key: .space, modifiers: []) {
            withAnimation {
                completionMode = completionMode.next
            }
        }
        .frame(minWidth: 500, maxWidth: 500)
    }
}

#Preview {
    PanelCompletionsView(
        completions: CompletionInstructionSD.samples,
        completionInWindow: {_,_  in},
        completionInApp: {_ in}
    )
}
#endif
