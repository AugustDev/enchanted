//
//  SettingsView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/12/2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("ollamaUri") private var ollamaUri: String = "http://localhost:11434"
    @AppStorage("vibrations") private var vibrations: Bool = true
    @AppStorage("colorScheme") private var colorScheme = AppColorScheme.system

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    
                    Button(action: {}) {
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
                Section(header: Text("Ollama")) {
                    TextField("Ollama server URI", text: $ollamaUri)
                    
                }
                
                Section("App") {
                    Toggle(isOn: $vibrations, label: {Label("Vibrations", systemImage: "water.waves")})
                    Picker(selection: $colorScheme) {
                        ForEach(AppColorScheme.allCases, id:\.self) { scheme in
                            Text(scheme.toString).tag(scheme.id)
                        }
                    } label: {
                        Label("Color Scheme", systemImage: "sun.max")
                    }
                }
            }
            .foregroundColor(Color(.label))
            
            Spacer()
        }
        .preferredColorScheme(colorScheme.toiOSFormat)
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
}
