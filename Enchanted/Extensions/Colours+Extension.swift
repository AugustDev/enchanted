//
//  Colours.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI

// MARK: - Palette
extension Color {
    static let primary = Color(.label)
    static let secondary =  Color(.systemGray)
    
    static let labelCustom = Color("label")
    static let bgCustom = Color("bg")
    static let grayCustom = Color("gray")
    static let gray2Custom = Color("gray2")
    static let gray3Custom = Color("gray3")
    static let gray4Custom = Color("gray4")
    static let gray5Custom = Color("gray5")
}

// MARK: - hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
