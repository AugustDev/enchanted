//
//  SelectTextSheet.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 01/05/2024.
//

#if os(iOS) || os(visionOS)
import SwiftUI
import UIKit

struct SelectTextSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextEditorFocused: Bool
    
    var message: MessageSD
    var body: some View {
        VStack {
            ZStack {
                Text("Select Text")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                
                HStack {
                    Spacer()
                    Button(action: {presentationMode.wrappedValue.dismiss()}) {
                        Image(systemName: "x.circle.fill")
                            .padding(7)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            
            TextEditor(text: .constant(message.content))
                .focusable()
                .focused($isTextEditorFocused)
                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                    if let textField = obj.object as? UITextView {
                        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                    }
                }
            #if os(visionOS)
                .frame(width: 600, height: 600)
            #endif
            
        }
        .textSelection(.enabled)
        .onAppear {
            isTextEditorFocused = true
        }
        
    }
}

#Preview {
    SelectTextSheet(message: MessageSD.sample[0])
}

#endif
