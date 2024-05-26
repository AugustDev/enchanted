//
//  ReadingAloudView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 26/05/2024.
//

import SwiftUI

struct ReadingAloudView: View {
    var onStopTap: () -> ()
    @State private var animationsRunning = false
    
    var body: some View {
        HStack {
            
            Text("Reading Aloud")
                .font(.system(size: 14))
            
            Image(systemName: "speaker.wave.3")
                .symbolEffect(.variableColor.iterative,  options: .repeat(100), value: animationsRunning)
                .scaledToFit()
                .frame(width: 18)
            
            Spacer()
            
            Button(action: onStopTap) {
                Image(systemName: "stop.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 15, weight: .semibold))
                    .padding(5)
            }
            .buttonStyle(GrowingButton())
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8).fill(Color.gray5Custom)
        }
        .padding()
        .onAppear {
            animationsRunning = true
        }
    }
}

#Preview {
    ReadingAloudView(onStopTap: {})
}
