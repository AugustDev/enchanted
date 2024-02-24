//
//  RetrievalView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 24/02/2024.
//

import SwiftUI

struct RetrievalView: View {
    @Environment(\.presentationMode) var presentationMode
    var databases: [DatabaseSD]
    @Binding var selectedDatabase: DatabaseSD?
    var documents: [DocumentSD]
    var onCreateDatabase: (String) -> ()
    
    @State private var showGuide = false
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {onCreateDatabase("Database dog")}) {
                        Text("New Database")
                    }
                    
                    Spacer()
                    
                    Button(action: {presentationMode.wrappedValue.dismiss()}) {
                        Text("Close")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(.label))
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Retrieval")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(Color(.label))
                    Spacer()
                }
            }
            .padding()
            .padding(.bottom)
            
            VStack {
                EmptyDatabaseView()
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                    .showIf(databases.isEmpty)
                
                HStack {
                    
                    Button(action: {}) {
                        Text("Index files")
                    }
                    .showIf(!documents.isEmpty)
                    
                    Spacer()
                    
                    Picker(selection: $selectedDatabase) {
                        ForEach(databases, id:\.self) { database in
                            Text(database.name).tag(Optional(database))
                        }
                    } label: {
                        Text("Database")
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                    }
                    .frame(maxWidth: 300)
                    .showIf(!databases.isEmpty)
                }
                
                DatabaseView(documents: documents)
                    .padding(.top, 20)
                    .showIf(!databases.isEmpty)
            }
            .padding([.horizontal, .bottom])
            
            HStack {
                
                Spacer()
                Button(action: {}) {
                    Text("Import files")
                }
                
                Button(action: {}) {
                    Text("Start Indexing")
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding()
        }
        .frame(minWidth: 700, maxWidth: 800, minHeight: 500)
    }
}

#Preview {
    RetrievalView(
        databases: DatabaseSD.sample,
        selectedDatabase: .constant(DatabaseSD.sample.first),
        //        documents: DocumentSD
        documents: [],
        onCreateDatabase: {_ in}
    )
    .frame(width: 700)
}
