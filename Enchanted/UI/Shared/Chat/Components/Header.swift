//
//  Header.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI

struct Header: View {
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(selectedModel.name)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                        .foregroundColor(.black)
                }
                
            }
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    Header()
}
