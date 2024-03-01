//
//  PanelCompletionsView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 29/02/2024.
//

import SwiftUI

struct PanelCompletionsView: View {
    var completions: [CompletionInstructionSD]
    var onClick: @MainActor (_ completion: CompletionInstructionSD) -> ()
    
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
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(completions) { completion in
                        CompletionButtonView(name: completion.name, keyboardCharacter: completion.keyboardCharacter, action: {
                            onClick(completion)
                        })
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
        }
        .frame(minWidth: 500, maxWidth: 500)
    }
}

#Preview {
    PanelCompletionsView(completions: CompletionInstructionSD.samples, onClick: {_ in})
}
