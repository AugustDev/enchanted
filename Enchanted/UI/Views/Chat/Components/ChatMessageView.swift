//
//  ChatMessageView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI
import MarkdownUI

struct ChatMessageView: View {
    var avatarName: String
    var name: String
    var text: String
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                ZStack {
                  Circle()
                        .foregroundColor(.green)
                  
                  Text(avatarName)
                        .font(.system(size: 9))
                        .foregroundStyle(.background)
                }
                .frame(width: 21, height: 21)
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .padding(.bottom, 2)
                    
                    Markdown(text)
                        .textSelection(.enabled)
                        .markdownTheme(.gitHub)
                        .font(.system(size: 16))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ChatMessageView(avatarName: "AM", name: "Mistral", text: "The derivative of a function describes how function changes.")
        .previewLayout(.sizeThatFits)
}
