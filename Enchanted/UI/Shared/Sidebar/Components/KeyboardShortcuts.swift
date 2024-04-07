//
//  KeyboardShortcuts.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 19/02/2024.
//

import SwiftUI

struct KeyboardShortcut: Identifiable {
    let id: Int
    var keys: [String]
    var description: String
}

struct KeyboardShortcutsDemo: View {
    @Environment(\.presentationMode) var presentationMode
    var shortcuts = [
        KeyboardShortcut(id: 1, keys: ["⌃", "⌘", "K"], description: "Open Panel Window"),
        KeyboardShortcut(id: 2, keys: ["⌘", "N"], description: "New Conversation"),
        KeyboardShortcut(id: 3, keys: ["⌘", "⌥", "S"], description: "Hide/Show sidebar"),
        KeyboardShortcut(id: 4, keys: ["⌘", "V"], description: "Paste text or image from clipboard into message box ")
    ]
    
    private func close() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Shortcuts")
                    .font(.title)
                    .fontWeight(.thin)
                    .enchantify()
                    .padding(.bottom, 30)
                
                Spacer()
                
                Button(action: close) {
                    Text("Close")
                }
                .buttonStyle(GrowingButton())
            }
            
            Table(shortcuts) {
                TableColumn("Shortcut") { shortcut in
                    Text(shortcut.keys.joined(separator: " + "))
                }
                .width(min: 100, max: 150)
                TableColumn("Description") { shortcut in
                    Text(String(shortcut.description))
                }
            }
        }
        .padding()
        .frame(width: 800, height: 600)
    }
}

#Preview {
    KeyboardShortcutsDemo()
}
