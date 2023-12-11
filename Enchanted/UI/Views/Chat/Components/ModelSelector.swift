//
//  ModelSelector.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/12/2023.
//

import SwiftUI

struct ModelSelector: View {
    var modelsList: [LanguageModelSD]
    @Binding var selectedModel: LanguageModelSD?
    //    var onSelect: (_ model: LanguageModelSD) -> ()
    
    var body: some View {
        Menu {
            ForEach(modelsList, id: \.self) { model in
                Button(action: {
                    withAnimation(.easeOut) {                        
                        selectedModel = model
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
    ModelSelector(
        modelsList: LanguageModelSD.sample,
        selectedModel: .constant(LanguageModelSD.sample[0])
    )
}
