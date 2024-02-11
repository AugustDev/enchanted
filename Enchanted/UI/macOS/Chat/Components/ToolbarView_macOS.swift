//
//  ToolbarView_macOS.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

#if os(macOS)
import SwiftUI

struct ToolbarView: View {
    var modelsList: [LanguageModelSD]
    var selectedModel: LanguageModelSD?
    var onSelectModel: @MainActor (_ model: LanguageModelSD?) -> ()
    var onNewConversationTap: () -> ()
    
    var body: some View {
        ModelSelectorView(
            modelsList: modelsList,
            selectedModel: selectedModel,
            onSelectModel: onSelectModel,
            showChevron: false
        )
        .frame(height: 20)
        
        Button(action: onNewConversationTap) {
            Image(systemName: "square.and.pencil")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundColor(Color.labelCustom)
        }
    }
}

#Preview {
    ToolbarView(
        modelsList: LanguageModelSD.sample,
        selectedModel: LanguageModelSD.sample[0],
        onSelectModel: {_ in},
        onNewConversationTap: {}
    )
}

#endif
