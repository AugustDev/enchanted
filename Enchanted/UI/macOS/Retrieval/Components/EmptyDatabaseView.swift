//
//  EmptyDatabaseView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 24/02/2024.
//

import SwiftUI

struct EmptyDatabaseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("How it works")
                .font(Font.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "4285f4"), Color(hex: "9b72cb"), Color(hex: "d96570"), Color(hex: "#d96570")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            HStack(alignment:. top, spacing: 20) {
                
                VStack {
                    Image(systemName: "plus.rectangle.on.folder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(Color(hex: "4285f4"))
                    
                    HStack(alignment: .top) {
                        Text("1.")
                            .font(Font.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "4285f4"), Color(hex: "9b72cb"), Color(hex: "d96570"), Color(hex: "#d96570")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Create a database of documents for your task. It may be course notes, legal documents, coding project or anything else. Files always stay local to your machine.")
                            .lineLimit(15)
                            .font(.system(size: 14))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
                            }
                    }
                    .padding(.vertical)
                }
                
                VStack {
                    Image(systemName: "doc.on.doc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(Color(hex: "9b72cb"))
                    
                    HStack(alignment: .top) {
                        Text("2.")
                            .font(Font.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "4285f4"), Color(hex: "9b72cb"), Color(hex: "d96570"), Color(hex: "#d96570")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Import documents. Enchanted will create text embeddings based on the selected model. Currently text and PDF files are supported.")
                            .lineLimit(15)
                            .font(.system(size: 14))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
                            }
                    }
                    .padding(.vertical)
                }
                .padding(.top, 80)
                
                VStack {
                    Image(systemName: "message.badge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(Color(hex: "d96570"))
                    
                    HStack(alignment: .top) {
                        Text("3.")
                            .font(Font.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "4285f4"), Color(hex: "9b72cb"), Color(hex: "d96570"), Color(hex: "#d96570")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Make prompts using your database. Enchanted will include snippets of relevant your documents when sending the prompt.")
                            .lineLimit(15)
                            .font(.system(size: 14))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
                            }
                    }
                    .padding(.vertical)
                }
                .padding(.top, 160)
            }
        }
    }
}

#Preview {
    EmptyDatabaseView()
        .frame(height: 500)
}
