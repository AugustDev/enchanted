//
//  UnreachableAPIView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

import SwiftUI

struct UnreachableAPIView: View {
    var body: some View {
        HStack {
            Text("Ollama is unreachable. Go to Settings and update your Ollama API endpoint.")
                .fontWeight(.medium)
                .font(.system(size: 14))
            Spacer()
        }
        .padding()
        .background(Color(.systemRed).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

#Preview {
    UnreachableAPIView()
}
