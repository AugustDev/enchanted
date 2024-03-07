//
//  EmptyConversaitonView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

import SwiftUI

struct EmptyConversaitonView: View, KeyboardReadable {
    @State var showPromptsAnimation = false
    @State var prompts: [SamplePrompts] = []
    var sendPrompt: (String) -> ()
#if os(iOS)
    @State var isKeyboardVisible = false
#endif
    
#if os(macOS)
    var columns = Array.init(repeating: GridItem(.flexible(), spacing: 15), count: 4)
#else
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
#endif
    @State var visibleItems = Set<Int>()
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 25) {
                Text("Enchanted")
                    .font(Font.system(size: 46, weight: .thin))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "4285f4"), Color(hex: "9b72cb"), Color(hex: "d96570"), Color(hex: "#d96570")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("How can I help you today?")
                    .font(.system(size: 25))
                    .foregroundStyle(Color(.systemGray))
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 15) {
                    ForEach(0..<prompts.prefix(4).count, id: \.self) { index in
                        Button(action: {sendPrompt(prompts[index].prompt)}) {
                            VStack(alignment: .leading) {
                                Text(prompts[index].prompt)
                                    .font(.system(size: 15))
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    Image(systemName: prompts[index].type.icon)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color.gray5Custom)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }
                        .opacity(visibleItems.contains(index) ? 1 : 0)
                        .animation(.easeIn(duration: 0.3).delay(0.2 * Double(index)), value: visibleItems)
                        .transition(.slide)
                        .showIf(showPromptsAnimation)
                        .buttonStyle(.plain)
                    }
                }
                .onAppear {
                    for index in 0..<4 {
                        DispatchQueue.main.async {
                            visibleItems.insert(index)
                        }
                    }
                }
                .frame(maxWidth: 700)
                .padding()
                .transition(AnyTransition(.opacity).combined(with: .slide))
#if os(iOS)
                .showIf(!isKeyboardVisible)
#endif
            }
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation {
                    prompts = SamplePrompts.samples.shuffled()
                    showPromptsAnimation = true
                }
            }
        }
#if os(iOS)
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            DispatchQueue.main.async {
                withAnimation {
                    isKeyboardVisible = newIsKeyboardVisible
                }
            }
        }
#endif
        
    }
}

#Preview(traits: .fixedLayout(width: 1000, height: 1000)) {
    EmptyConversaitonView(sendPrompt: {_ in})
}
