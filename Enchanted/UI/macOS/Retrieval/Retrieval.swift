//
//  Retrieval.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 24/02/2024.
//

import SwiftUI

struct Retrieval: View {
    @State var retrievalStore = RetrievalStore.shared
    @State var languageModelStore = LanguageModelStore.shared   
    
    func createDatabase(name: String) {
        Task {
            try? await retrievalStore.createDatabase(name: name, indexPath: "./www.com")
        }
    }
    
    var body: some View {
        RetrievalView(
            databases: retrievalStore.databases,
            selectedDatabase: $retrievalStore.selectedDatabase,
            documents: retrievalStore.selectedDatabase?.documents ?? [],
            onCreateDatabase: createDatabase
        )
    }
}
