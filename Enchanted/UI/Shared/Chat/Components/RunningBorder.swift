//
//  RunningBorder.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 28/01/2024.
//

import SwiftUI

struct RunningBorder: ViewModifier {
    @State private var rotation = 0.0
    var animated: Bool
    
    func body(content: Content) -> some View {
        if animated {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            AngularGradient(gradient: Gradient(colors: [.indigo, .blue, .red, .orange, .indigo]), center: .center, startAngle: .degrees(rotation), endAngle: .degrees(rotation+360)).opacity(0.5),
                            lineWidth: 3.5
                        )
                )
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func runningBorder(animated: Bool) -> some View {
        modifier(RunningBorder(animated: animated))
    }
}

#Preview {
    Rectangle()
        .runningBorder(animated: true)
}
