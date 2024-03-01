//
//  Completions.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 01/03/2024.
//

import SwiftUI

struct CompletionsEditor: View {
    @State var completionsStore = CompletionsStore.shared
    
    var body: some View {
        CompletionsEditorView(
            completions: $completionsStore.completions,
            onSave: completionsStore.save,
            onDelete: completionsStore.delete
        )
    }
}
