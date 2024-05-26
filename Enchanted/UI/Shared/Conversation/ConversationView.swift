//
//  ConversationView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 26/05/2024.
//

import SwiftUI


struct SiriAnimation: View {
    @State var isRotating = false
    
    var body: some View {
//        NavigationStack {
            Text("SwiftUI Siri Animation")
                .font(.largeTitle)
                .toolbar {
//                    ToolbarItem(placement: .bottomOrnament) {
                        ZStack {
                            ZStack {
                                Image("shadow")
                                Image("icon-bg")
                                    .scaleEffect(0.5)
                                
                                Image("blue-right")
                                    .rotationEffect(.degrees(isRotating ? -359 : 420))
                                    .hueRotation(.degrees(isRotating ? 720 : -50))
                                    .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: isRotating ? -5 : 15))
                                    .scaleEffect(0.5)
                                    .blendMode(.colorBurn)
                                
                                Image("blue-middle")
                                    .rotationEffect(.degrees(isRotating ? -359 : 420))
                                    .hueRotation(.degrees(isRotating ? -150 : 0))
                                    .rotation3DEffect(.degrees(75), axis: (x: isRotating ? 1 : 5, y: 0, z: 0))
                                    .blur(radius: 25)
                                    .scaleEffect(0.5)
                                
                                Image("pink-top")
                                    .rotationEffect(.degrees(isRotating ? 320 : -359))
                                    .hueRotation(.degrees(isRotating ? -270 : 60))
                                
                                Image("pink-left")
                                    .rotationEffect(.degrees(isRotating ? -359 : 179))
                                    .hueRotation(.degrees(isRotating ? -220 : 300))
                                    .scaleEffect(0.5)
                                
                                Image("intersect")
                                    .rotationEffect(.degrees(isRotating ? 30 : -420))
                                    .hueRotation(.degrees(isRotating ? 0 : 720))
                                    .rotation3DEffect(.degrees(-360), axis: (x: 1, y: 5, z: 1))
                                
                                // Here
                                Image("green-right")
                                    .rotationEffect(.degrees(isRotating ? -300 : 359))
                                    .hueRotation(.degrees(isRotating ? 300 : -15))
                                    .rotation3DEffect(.degrees(-15), axis: (x: 1, y: isRotating ? -1 : 1, z: 0))
                                    .scaleEffect(0.5)
                                    .blur(radius: 25)
                                    .opacity(0.5)
                                    .blendMode(.colorBurn)
                                
                                Image("green-left")
                                    .rotationEffect(.degrees(isRotating ? 359 : -358))
                                    .hueRotation(.degrees(isRotating ? 180 :50))
                                    .rotation3DEffect(.degrees(330), axis: (x: 1, y:isRotating ? -5 : 15, z: 0))
                                    .scaleEffect(0.5)
                                    .blur(radius: 25)
                                
                                Image("bottom-pink")
                                    .rotationEffect(.degrees(isRotating ? 400 : -359))
                                    .hueRotation(.degrees(isRotating ? 0 : 230))
                                    .opacity(0.25)
                                    .blendMode(.multiply)
                                    .rotation3DEffect(.degrees(75), axis: (x: 5, y:isRotating ? 1 : -45, z: 0))
                            }
                            .blendMode(isRotating ? .hardLight : .difference )
                            
                            Image("highlight")
                                .rotationEffect(.degrees(isRotating ? 359 : 250))
                                .hueRotation(.degrees(isRotating ? 0 : 230))
                                .padding()
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: false)) {
                                        isRotating.toggle()
                                    }
                                }
                        }
                        .padding(.top)
                        .scaleEffect(0.4)
                        .frame(width: 60, height: 60)
                    }
//                }
//        }
    }
}

struct ConversationView: View {
    var body: some View {
        SiriAnimation()
    }
}

#Preview {
    ConversationView()
}
