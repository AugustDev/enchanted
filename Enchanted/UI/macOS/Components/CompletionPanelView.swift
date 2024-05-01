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
    case completionsInApp
    
    var next: CompletionsPromptMode {
        switch self {
        case .completionsInApp:
            return .completionsInCurrentWindow
        case .completionsInCurrentWindow:
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
    
    @State var customCompletionInstruction: String = ""
    @State var showCustomCompletionInstructionTextField = false
    @FocusState var focusCustomCompletionsTectField: Bool
    @Namespace var animation
    
    var filetedCompletions: [CompletionInstructionSD] {
        if let selectedCompletion = selectedCompletion {
            return [selectedCompletion]
        }
        return completions
    }
    
    func changeCompletionMode() {
        withAnimation {
            completionMode = completionMode.next
        }
    }
    
    @MainActor
    func submitCompletion(_ completion: CompletionInstructionSD) {
        withAnimation {
            selectedCompletion = completion
            switch completionMode {
            case .completionsInCurrentWindow:
                completionInWindow(completion, false)
            case .completionsInApp:
                completionInApp(completion)
            }
        }
    }
    
    var customCompletionButton: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.15)) {
                showCustomCompletionInstructionTextField = true
                focusCustomCompletionsTectField = true
            }
        }) {
            HStack {
                Text("TAB")
                    .textCase(.uppercase)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .font(.system(size: 10, weight: .medium, design: .default))
                
                Text("Your Command")
                    .enchantify()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundStyle(.label)
            .background(RoundedRectangle(cornerRadius: 5).fill(.bgCustom))
            
        }
        .buttonStyle(GrowingButton())
        .keyboardShortcut(.tab, modifiers: [])
        .matchedGeometryEffect(id: "customCommand", in: animation)
    }
    
    var customCompletionInstructionTextField: some View {
        HStack {
            Button(action: {
                withAnimation(.easeOut(duration: 0.15)) {
                    showCustomCompletionInstructionTextField = false
                }
            }) {
                Text("TAB")
                    .textCase(.uppercase)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .font(.system(size: 10, weight: .medium, design: .default))
            }
            .buttonStyle(GrowingButton())
            .keyboardShortcut(.tab, modifiers: [])
            
            TextField("Instruction", text: $customCompletionInstruction)
                .textFieldStyle(.plain)
                .focused($focusCustomCompletionsTectField)
                .onSubmit {
                    let completion = CompletionInstructionSD(
                        name: "Custom Command",
                        keyboardCharacterStr: "",
                        instruction: customCompletionInstruction + "\n\n",
                        order: 0)
                    
                    DispatchQueue.main.async {
                        submitCompletion(completion)
                    }
                }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .foregroundStyle(.label)
        .background(RoundedRectangle(cornerRadius: 5).fill(.bgCustom))
        .matchedGeometryEffect(id: "customCommand", in: animation)
        .padding(.bottom, 10)
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
                
                HStack(alignment: .firstTextBaseline) {
                    Text("Tap")
                    Image(systemName: "space")
                    Text("to begin")
                }
                .showIf(selectedCompletion != nil)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                WrappingHStack(alignment: .leading) {
                    ForEach(filetedCompletions) { completion in
                        CompletionButtonView(
                            name: completion.name,
                            keyboardCharacter: completion.keyboardCharacter,
                            action: {
                                submitCompletion(completion)
                            }
                        )
                        .keyboardShortcut(KeyEquivalent(completion.keyboardCharacter), modifiers: [])
                    }
                    
                    customCompletionButton
                        .showIf(!showCustomCompletionInstructionTextField)
                }
                
                if showCustomCompletionInstructionTextField {
                    customCompletionInstructionTextField
                }
            }
            .padding(.bottom, 10)
            
            HStack(alignment: .center) {
                switch completionMode {
                case .completionsInApp:
                    Text("Respond in **App**.")
                case .completionsInCurrentWindow:
                    Text("Respond in current **Window**.")
                }
                
                Button(action: changeCompletionMode) {
                    HStack(spacing: 4) {
                        Text("⇧")
                            .font(.caption2)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(RoundedRectangle(cornerRadius: 3).fill(.bgCustom))
                        
                        Text("+")
                            .font(.footnote)
                        
                        Text("SPACE")
                            .font(.caption2)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(RoundedRectangle(cornerRadius: 3).fill(.bgCustom))
                    }
                        
                }
                .buttonStyle(GrowingButton())
                
                Text("to switch")
            }
            
            .padding(.horizontal, 8)
            .showIf(selectedCompletion == nil)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8).fill(.ultraThickMaterial)
        }
        .onKeyboardShortcut(key: .space, modifiers: [.shift]) {
            changeCompletionMode()
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
