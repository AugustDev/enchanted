//
//  SidebarView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import SwiftUI

struct SidebarView: View {
    
    var conversations: [ConversationSD]
    var onConversationTap: (_ conversation: ConversationSD) -> ()
    var onConversationDelete: (_ conversation: ConversationSD) -> ()
    @State var showSettings = false
    
    var body: some View {
        VStack {
            ScrollView() {
                ConversationHistoryList(
                    conversations: conversations,
                    onTap: onConversationTap,
                    onDelete: onConversationDelete
                )
            }
            .scrollIndicators(.never)
            
            Button(action: {
                showSettings.toggle()
                Haptics.shared.play(.medium)
            }) {
                HStack {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("Settings")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                .foregroundColor(Color(.label))
                .padding(.vertical)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .sheet(isPresented: $showSettings) {
            Settings()
        }
    }
}

#Preview {
    SidebarView(conversations: ConversationSD.sample, onConversationTap: {_ in}, onConversationDelete: {_ in})
}
