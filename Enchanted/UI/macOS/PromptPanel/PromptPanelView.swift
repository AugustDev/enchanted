//
//  PromptPanelView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

import SwiftUI

struct PromptPanelView: View {
    @FocusState private var focused: Bool?
    @State var prompt: String = ""
    var onSubmit: @MainActor (_ prompt: String) -> ()
    
    var body: some View {
        HStack {
            Image(systemName: "message")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundColor(.grayCustom)
            
            TextField("How can I help today", text: $prompt)
                .font(.title)
                .focusEffectDisabled()
                .padding(8)
                .background(Color.clear)
                .focused($focused, equals: true)
                .textFieldStyle(PlainTextFieldStyle())
                .onSubmit {
                    onSubmit(prompt)
                }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .onAppear {
            prompt = ""
            focused = true
        }
    }
}

#Preview {
    PromptPanelView(onSubmit: {_ in})
}
