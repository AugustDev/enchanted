//
//  HapticsService.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 28/12/2023.
//

#if os(iOS)
import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }

    private func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        let vibrations = UserDefaults.standard.bool(forKey: "vibrations")
        if vibrations {
            UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
        }
    }
    
    private func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        let vibrations = UserDefaults.standard.bool(forKey: "vibrations")
        if vibrations {
            UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
        }
    }
    
    func lightTap() {
        play(.light)
    }
    
    func mediumTap() {
        play(.medium)
    }
}
#elseif os(macOS)
class Haptics {
    static let shared = Haptics()
    func lightTap() {}
    func mediumTap() {}
}
#endif
