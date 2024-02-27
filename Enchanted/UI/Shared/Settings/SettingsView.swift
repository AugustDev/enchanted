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
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(.label))
                    }
                    

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
            
            Form {
                Section(header: Text("Ollama").font(.headline)) {
                    TextField("Ollama server URI", text: $ollamaUri, onCommit: checkServer)
                        .textContentType(.URL)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
#if os(iOS)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
#endif
                    
                    TextField("System prompt", text: $systemPrompt, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
#if os(iOS)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
#endif
                    
                    Picker(selection: $defaultOllamModel) {
                        ForEach(ollamaLangugeModels, id:\.self) { model in
                            Text(model.name).tag(model.name)
                        }
                    } label: {
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
                    }
                }
                
                Section(header: Text("APP").font(.headline).padding(.top, 20)) {
                    
#if os(iOS)
                    Toggle(isOn: $vibrations, label: {
                        Label("Vibrations", systemImage: "water.waves")
                            .foregroundStyle(Color.label)
                    })
#endif
                    
                    
                    Picker(selection: $colorScheme) {
                        ForEach(AppColorScheme.allCases, id:\.self) { scheme in
                            Text(scheme.toString).tag(scheme.id)
                        }
                    } label: {
                        Label("Appearance", systemImage: "sun.max")
                            .foregroundStyle(Color.label)
                    }
                    
                    Button(action: {deleteConversationsDialog.toggle()}) {
                        HStack {
                            Spacer()
                            
                            Text("Delete All Conversations")
                                .foregroundStyle(Color(.systemRed))
                                .padding(.vertical, 6)
                            
                            Spacer()
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
        .preferredColorScheme(colorScheme.toiOSFormat)
        .confirmationDialog("Delete All Conversations?", isPresented: $deleteConversationsDialog) {
            Button("Delete", role: .destructive) { deleteAllConversations() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Delete All Conversations?")
        }
    }
}

#Preview {
    SettingsView(
        ollamaUri: .constant(""),
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

