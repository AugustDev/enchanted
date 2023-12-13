//
//  SettingsView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/12/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(LanguageModelStore.self) private var languageModelStore
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("ollamaUri") private var ollamaUri: String = ""
    @AppStorage("vibrations") private var vibrations: Bool = true
    @AppStorage("colorScheme") private var colorScheme = AppColorScheme.system
    @State var ollamaStatus: Bool?

    private func save() {
        OllamaService.reinit(url: ollamaUri)
        Task {
            presentationMode.wrappedValue.dismiss()
            try? await languageModelStore.loadModels()
        }
    }
    
    private func checkServer() {
        Task {
            OllamaService.reinit(url: ollamaUri)
            ollamaStatus = await OllamaService.shared.reachable()
            try? await languageModelStore.loadModels()
        }
    }
    
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
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(10)
                        .background(Color(.systemGray5))
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
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, 20)
            }
            .padding()
            
            
        
            
            Spacer()
        }
        .preferredColorScheme(colorScheme.toiOSFormat)
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    SettingsView()
}
