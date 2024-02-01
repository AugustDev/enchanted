//
//  ModelSelector.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/12/2023.
//

import SwiftUI

struct ModelSelectorView: View {
    var modelsList: [LanguageModelSD]
    var selectedModel: LanguageModelSD?
    var onSelectModel: @MainActor (_ model: LanguageModelSD?) -> ()
    
    var body: some View {
        Menu {
            ForEach(modelsList, id: \.self) { model in
                Button(action: {
                    withAnimation(.easeOut) {    
                        onSelectModel(model)
                    }
                }) {
                    Text(model.name)
                        .tag(model.name)
                }
            }
        } label: {
            HStack(alignment: .center) {
                if let selectedModel = selectedModel {
                    HStack(alignment: .bottom, spacing: 5) {
                        Text(selectedModel.prettyName)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.label))
                        
                        Text(selectedModel.prettyVersion)
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray))
                    }
                }
                
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                    .foregroundColor(Color(.label))
            }
        }
    }
}

#Preview {
    ModelSelectorView(
        modelsList: LanguageModelSD.sample,
        selectedModel: LanguageModelSD.sample[0], onSelectModel: {_ in}
    )
}
