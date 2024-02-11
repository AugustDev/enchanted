//
//  SettingsView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/12/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var ollamaUri: String
    @Binding var systemPrompt: String
    @Binding var vibrations: Bool
    @Binding var colorScheme: AppColorScheme
    @Binding var defaultOllamModel: String
    @State var ollamaStatus: Bool?
    var save: () -> ()
    var checkServer: () -> ()
    var deleteAllConversations: () -> ()
    var ollamaLangugeModels: [LanguageModelSD]
    
    @State private var deleteConversationsDialog = false
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    
                    Button(action: save) {
                        Text("Save")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(.label))
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Settings")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(Color(.label))
                    Spacer()
                }
            }
            .padding()
            
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("OLLAMA")
                            .foregroundStyle(Color(.systemGray))
                            .font(.system(size: 12))
                        
                        Spacer()
                        
                    }
                    TextField("Ollama server URI", text: $ollamaUri, onCommit: checkServer)
#if os(iOS)
                        .keyboardType(.URL)
#endif
                        .textContentType(.URL)
                        .disableAutocorrection(true)
#if os(iOS)
                        .autocapitalization(.none)
#endif
                        .padding(10)
#if os(iOS)
                        .background(Color(.secondarySystemGroupedBackground))
#endif
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                if let ollamaStatus = ollamaStatus {
                    HStack {
                        if ollamaStatus {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color(.systemGreen))
                            
                            Text("Successfully connected to server")
                                .font(.system(size: 14))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color(.systemRed))
                            
                            Text("Could not connect to server")
                                .font(.system(size: 14))
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                
                TextField("System prompt", text: $systemPrompt, axis: .vertical)
                    .frame(height: 100)
                    .lineLimit(5, reservesSpace: true)
                    .padding(10)
#if os(iOS)
                    .background(Color(.secondarySystemGroupedBackground))
#endif
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                HStack {
                    Label {
                        Text("Default Model")
                    } icon: {
                        Image("ollama")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(.label))
                            .frame(width: 24, height: 24)
                    }
                    
                    Spacer()
                    
                    Picker(selection: $defaultOllamModel) {
                        ForEach(ollamaLangugeModels, id:\.self) { model in
                            Text(model.name).tag(model.name)
                        }
                    } label: {
                        Label("Color Scheme", systemImage: "sun.max")
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
#if os(iOS)
                .background(Color(.secondarySystemGroupedBackground))
#endif
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .showIf(!ollamaLangugeModels.isEmpty)
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("APP")
                            .foregroundStyle(Color(.systemGray))
                            .font(.system(size: 12))
                        
                        Spacer()
                    }
                    
                    VStack {
                        HStack {
                            Toggle(isOn: $vibrations, label: {Label("Vibrations", systemImage: "water.waves")})
                        }
                        
                        Divider()
                        
                        HStack {
                            Label("Color Scheme", systemImage: "sun.max")
                            Spacer()
                            Picker(selection: $colorScheme) {
                                ForEach(AppColorScheme.allCases, id:\.self) { scheme in
                                    Text(scheme.toString).tag(scheme.id)
                                }
                            } label: {
                                Label("Color Scheme", systemImage: "sun.max")
                            }
                        }
                    }
                    .padding(10)
#if os(iOS)
                    .background(Color(.secondarySystemGroupedBackground))
#endif
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    
                    VStack {
                        Button(action: {deleteConversationsDialog.toggle()}) {
                            HStack {
                                Spacer()
                                
                                Text("Delete All Conversations")
                                    .foregroundStyle(Color(.systemRed))
                                    .padding(.vertical, 2)
                                
                                Spacer()
                            }
                        }
                        .confirmationDialog("Delete All Conversations?", isPresented: $deleteConversationsDialog) {
                            Button("Delete", role: .destructive) { deleteAllConversations() }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Delete All Conversations?")
                        }
                    }
                    .padding(10)
#if os(iOS)
                    .background(Color(.secondarySystemGroupedBackground))
#endif
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, 20)
            }
            .padding()
            
            
            
            
            Spacer()
        }
        .preferredColorScheme(colorScheme.toiOSFormat)
#if os(iOS)
        .background(Color(.systemGroupedBackground))
#endif
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    SettingsView(
        ollamaUri: .constant("http://localhost"),
        systemPrompt: .constant(""),
        vibrations: .constant(true),
        colorScheme: .constant(.light),
        defaultOllamModel: .constant("llama2"),
        save: {},
        checkServer: {},
        deleteAllConversations: {},
        ollamaLangugeModels: LanguageModelSD.sample
    )
}
