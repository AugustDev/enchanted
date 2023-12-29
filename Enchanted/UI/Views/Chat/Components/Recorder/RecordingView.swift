//
//  SwiftUIView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 18/12/2023.
//

import SwiftUI
import AVFoundation

struct RecordingView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @Binding var isRecording: Bool
    var onComplete: (_ transcription: String) -> () = {_ in}
    
    private func toggleRecord() {
        Task {
            await speechRecognizer.userInit()
            await toggleTranscribing()
        }
        Haptics.shared.play(.medium)
    }
    
    private func toggleTranscribing() async {
        if isRecording {
            speechRecognizer.stopTranscribing()
            onComplete(speechRecognizer.transcript)
            isRecording = false
        } else {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
            isRecording = true
        }
    }
    
    var body: some View {
        Button(action: toggleRecord) {
            if isRecording {
                ZStack {
                    Color(.systemBlue)
                    
                    Image(systemName: "square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(.systemBackground))
                        .frame(width: 8)
                }
                .clipShape(Circle())
                .frame(width: 20, height: 20)
            } else {
                Image(systemName: "waveform")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundStyle(Color(.systemGray))
            }
        }
    }
}


struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(isRecording: .constant(true))
    }
}
