//
//  UnreachableAPIView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

import SwiftUI
import ActivityIndicatorView

struct UnreachableAPIView: View {
    @State var showSettings = false
    
    var body: some View {
        HStack {
            VStack {
                Text("Ollama is unreachable. Go to Settings and update your Ollama API endpoint. ")
                    .lineLimit(nil)
                    .minimumScaleFactor(0.5)
                    .fontWeight(.medium)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
            ActivityIndicatorView(isVisible: .constant(true), type: .growingCircle)
                 .frame(width: 21, height: 21)
                 .padding(.horizontal)
            
            Button(action: {showSettings.toggle()}) {
                Text("Settings")
                    .foregroundStyle(Color.white)
                    .fontWeight(.semibold)
            }
            .padding(8)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .buttonStyle(GrowingButton())
        }
        .padding()
        .background(Color(.pink).opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
       .sheet(isPresented: $showSettings) {
           Settings()
       }
    }
}

#Preview {
    UnreachableAPIView()
}
