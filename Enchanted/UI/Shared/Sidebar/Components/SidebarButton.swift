//
//  SidebarButton.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 19/02/2024.
//

import SwiftUI

struct SidebarButton: View {
    var title: String
    var image: String
    var onClick: () -> ()
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                
                Text(title)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .fontWeight(.regular)
            }
            .padding(8)
            .foregroundColor(Color(.label))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SidebarButton(title: "Settings", image: "gearshape.fill", onClick: {})
}
