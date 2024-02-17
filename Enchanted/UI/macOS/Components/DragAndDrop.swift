//
//  DragAndDrop.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 17/02/2024.
//

import SwiftUI

struct DragAndDrop: View {
    var cornerRadius: CGFloat = 15
    
    var body: some View {
        ZStack {
            Color.clear
            
            HStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.system(size: 25))
                Text("Drop your image here")
                    .font(.title2)
            }
            .foregroundColor(.label)
        }
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, lineJoin: .round, dash: [10]))
                .foregroundColor(.grayCustom)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    DragAndDrop()
        .frame(height: 100)
}
