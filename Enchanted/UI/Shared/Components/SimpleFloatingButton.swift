//
//  SimpleFloatingButton.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 18/02/2024.
//

import SwiftUI

struct SimpleFloatingButton: View {
    var systemImage: String
    var onClick: () -> ()
    
    var body: some View {
        Button(action: onClick) {
            Image(systemName: systemImage)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.label)
                .frame(height: 18)
        }
        .buttonStyle(GrowingButton())
    }
}

#Preview {
    SimpleFloatingButton(systemImage: "photo.fill", onClick: {})
        .frame(width: 100, height: 100)
}
