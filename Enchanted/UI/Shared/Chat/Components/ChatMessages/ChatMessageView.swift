//
//  ChatMessageView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI
import MarkdownUI
import Splash
import ActivityIndicatorView

struct ChatMessageView: View {
    @Environment(\.colorScheme) var colorScheme
    var message: MessageSD
    var showLoader: Bool = false
    var userInitials: String
    @Binding var editMessage: MessageSD?
    @State private var mouseHover = false
    
    var roleName: String  { 
        let userInitialsNotEmpty = userInitials != "" ? userInitials : "AM"
        return message.role == "user" ? userInitialsNotEmpty.uppercased() : "AI"
    }
    
    var image: PlatformImage? {
        message.image != nil ? PlatformImage(data: message.image!) : nil
    }
    
    private var codeHighlightColorScheme: Splash.Theme {
        switch colorScheme {
        case .dark:
            return .wwdc17(withFont: .init(size: 16))
        default:
            return .sunset(withFont: .init(size: 16))
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    if message.role == "user" {
                        ZStack {
                            Circle()
                                .foregroundColor(.green)
                            
                            Text(roleName)
                                .font(.system(size: 11))
                                .foregroundStyle(.background)
                            
                        }
                        .frame(width: 24, height: 24)
                        
                    } else {
                        Image("logo-nobg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(message.role.capitalized)
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .padding(.bottom, 2)
                                .frame(height: 27)
                            
                            ActivityIndicatorView(isVisible: .constant(true), type: .rotatingDots(count: 5))
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(-90))
                                .showIf(showLoader)
                        }
                        
                        Markdown(message.content)
                            .textSelection(.enabled)
                            .markdownCodeSyntaxHighlighter(.splash(theme: codeHighlightColorScheme))
                            .markdownTheme(MarkdownColours.enchantedTheme)
                        
                        if let uiImage = image {
#if os(iOS)
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
#elseif os(macOS)
                            Image(nsImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
#endif
                            
                        }
                    }
                    
                    Spacer()
                }
            }
            
#if os(macOS)
            HStack(spacing: 0) {
                Button(action: {Clipboard.shared.setString(message.content)}) {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(GrowingButton())
                .padding(8)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .showIf(mouseHover)
                
                Button(action: {editMessage = message}) {
                    Image(systemName: "pencil")
                }
                .buttonStyle(GrowingButton())
                .padding(8)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .showIf(mouseHover)
                .showIf(message.role == "user")
            }
            
#endif
        }
#if os(macOS)
        .onHover { over in
            withAnimation(.easeInOut(duration: 0.3)) {
                mouseHover = over
            }
        }
#endif
    }
}

#Preview {
    VStack {
        ChatMessageView(message: MessageSD.sample[0], userInitials: "AM", editMessage: .constant(nil))
            .previewLayout(.sizeThatFits)
        
        ChatMessageView(message: MessageSD(content: "```python \nprint(5+5)\n```", role: "ai"), userInitials: "AM", editMessage: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}
