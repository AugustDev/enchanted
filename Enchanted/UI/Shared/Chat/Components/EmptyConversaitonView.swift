//
//  EmptyConversaitonView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

import SwiftUI

struct EmptyConversaitonView: View {
    @State var showPrompts = false
    @State var prompts: [SamplePrompts] = []
    var sendPrompt: (String) -> ()
    
#if os(macOS)
    var columns = Array.init(repeating: GridItem(.flexible(), spacing: 15), count: 4)
#else
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
#endif
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 25) {
                Text("Enchanted")
                    .font(Font.system(size: 46, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "4285f4"), Color(hex: "9b72cb"), Color(hex: "d96570"), Color(hex: "#d96570")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Start new conversation")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(.systemGray))
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 15) {
                    ForEach(prompts.prefix(4), id: \.self) { prompt in
                        Button(action: {sendPrompt(prompt.prompt)}) {
                            VStack(alignment: .leading) {
                                Text(prompt.prompt)
                                    .font(.system(size: 15))
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    Image(systemName: prompt.type.icon)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color.gray5Custom)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        }
                        .transition(.slide)
                        .showIf(showPrompts)
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: 700)
                .padding()
            }
            Spacer()
        }
        .onAppear {
            withAnimation {
                prompts = SamplePrompts.samples.shuffled()
                showPrompts = true
            }
        }
    }
}

#Preview(traits: .fixedLayout(width: 1000, height: 1000)) {
    EmptyConversaitonView(sendPrompt: {_ in})
}
