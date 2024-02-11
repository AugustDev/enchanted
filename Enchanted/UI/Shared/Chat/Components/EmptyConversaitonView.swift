//
//  EmptyConversaitonView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

import SwiftUI

struct EmptyConversaitonView: View {
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 25) {
                Image("logo-nobg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .scaleEffect(animationAmount)
                    .animation(
                        .snappy(duration: 0.6, extraBounce: 0.3)
                        .delay(3)
                        .repeatForever(autoreverses: true),
                        value: animationAmount)
                    .onAppear {
                        animationAmount = 1.3
                    }
                
                Text("Start new conversation")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(.systemGray))
            }
            Spacer()
        }
    }
}

#Preview {
    EmptyConversaitonView()
}
