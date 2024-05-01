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
    @Binding var editMessage: MessageSD?
    @State private var mouseHover = false
    
    var roleName: String  { 
        message.role == "user" ? "AM" : "AI"
    }
    
    var image: PlatformImage? {
        message.image != nil ? PlatformImage(data: message.image!) : nil
    }
    
    let enchantedTheme = Theme()
        .text {
            FontSize(16)
        }
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
            BackgroundColor(.secondaryBackground)
        }
        .strong {
            FontWeight(.semibold)
        }
        .link {
            ForegroundColor(.link)
        }
        .heading1 { configuration in
            VStack(alignment: .leading, spacing: 0) {
                configuration.label
                    .relativePadding(.bottom, length: .em(0.3))
                    .relativeLineSpacing(.em(0.125))
                    .markdownMargin(top: 24, bottom: 16)
                    .markdownTextStyle {
                        FontWeight(.semibold)
                        FontSize(.em(2))
                    }
                Divider().overlay(Color.divider)
            }
        }
        .heading2 { configuration in
            VStack(alignment: .leading, spacing: 0) {
                configuration.label
                    .relativePadding(.bottom, length: .em(0.3))
                    .relativeLineSpacing(.em(0.125))
                    .markdownMargin(top: 24, bottom: 16)
                    .markdownTextStyle {
                        FontWeight(.semibold)
                        FontSize(.em(1.5))
                    }
                Divider().overlay(Color.divider)
            }
        }
        .heading3 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(.em(1.25))
                }
        }
        .heading4 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                }
        }
        .heading5 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(.em(0.875))
                }
        }
        .heading6 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.semibold)
                    FontSize(.em(0.85))
                    ForegroundColor(.tertiaryText)
                }
        }
        .paragraph { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: 0, bottom: 16)
        }
        .blockquote { configuration in
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.border)
                    .relativeFrame(width: .em(0.2))
                configuration.label
                    .markdownTextStyle { ForegroundColor(.secondaryText) }
                    .relativePadding(.horizontal, length: .em(1))
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .codeBlock { configuration in
            codeBlock(configuration)
        }
        .listItem { configuration in
            configuration.label
                .padding(.bottom, 10)
        }
        .taskListMarker { configuration in
            Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.checkbox, Color.checkboxBackground)
                .imageScale(.small)
                .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
        }
        .table { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .markdownTableBorderStyle(.init(color: .border))
                .markdownTableBackgroundStyle(
                    .alternatingRows(Color.background, Color.secondaryBackground)
                )
                .markdownMargin(top: 0, bottom: 16)
        }
        .tableCell { configuration in
            configuration.label
                .markdownTextStyle {
                    if configuration.row == 0 {
                        FontWeight(.semibold)
                    }
                    BackgroundColor(nil)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 6)
                .padding(.horizontal, 13)
                .relativeLineSpacing(.em(0.25))
        }
        .thematicBreak {
            Divider()
                .relativeFrame(height: .em(0.25))
                .overlay(Color.border)
                .markdownMargin(top: 24, bottom: 24)
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
                                .font(.system(size: 16))
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
                            .markdownTheme(enchantedTheme)
                        
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
            HStack {
                Button(action: {Clipboard.shared.setString(message.content)}) {
                    Text("Copy")
                }
                .buttonStyle(GrowingButton())
                .padding(8)
                .background(Color.gray5Custom)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .showIf(mouseHover)
                
                Button(action: {editMessage = message}) {
                    Text("Edit")
                }
                .buttonStyle(GrowingButton())
                .padding(8)
                .background(Color.gray5Custom)
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
    Group {
        ChatMessageView(message: MessageSD.sample[0], editMessage: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}

extension SwiftUI.Color {
    fileprivate static let text = Color(
        light: Color(rgba: 0x0606_06ff), dark: Color(rgba: 0xfbfb_fcff)
    )
    fileprivate static let secondaryText = Color(
        light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x9294_a0ff)
    )
    fileprivate static let tertiaryText = Color(
        light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x6d70_7dff)
    )
    fileprivate static let background = Color(
        light: .white, dark: Color(rgba: 0x1819_1dff)
    )
    fileprivate static let secondaryBackground = Color(
        light: Color(rgba: 0xf7f7_f9ff), dark: Color(rgba: 0x2526_2aff)
    )
    fileprivate static let link = Color(
        light: Color(rgba: 0x2c65_cfff), dark: Color(rgba: 0x4c8e_f8ff)
    )
    fileprivate static let border = Color(
        light: Color(rgba: 0xe4e4_e8ff), dark: Color(rgba: 0x4244_4eff)
    )
    fileprivate static let divider = Color(
        light: Color(rgba: 0xd0d0_d3ff), dark: Color(rgba: 0x3334_38ff)
    )
    fileprivate static let checkbox = Color(rgba: 0xb9b9_bbff)
    fileprivate static let checkboxBackground = Color(rgba: 0xeeee_efff)
}

@ViewBuilder
private func codeBlock(_ configuration: CodeBlockConfiguration) -> some View {
    var language: String {
        let language = configuration.language ?? "code"
        return language != "" ? language : "code"
    }
    
    VStack(spacing: 0) {
        HStack {
            Text(language)
                .font(.system(size: 13, design: .monospaced))
                .fontWeight(.semibold)
            Spacer()
            
            Button(action: {
                Clipboard.shared.setString(configuration.content)
            }) {
                Image(systemName: "clipboard")
                    .padding(7)
            }
            .buttonStyle(GrowingButton())
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(Color.secondaryBackground)
        
        Divider()
        
        ScrollView(.horizontal) {
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .relativeLineSpacing(.em(0.225))
                .markdownTextStyle {
                    FontFamilyVariant(.monospaced)
                    FontSize(.em(0.85))
                }
                .padding(16)
        }
    }
    .background(Color.secondaryBackground)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .markdownMargin(top: .zero, bottom: .em(0.8))
}
