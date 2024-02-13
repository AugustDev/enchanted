//
//  HotkeyService.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/02/2024.
//

#if os(macOS)
import Foundation
import Magnet
import SwiftUI
 
final class HotkeyService {
    static let shared = HotkeyService()
    
    func register(callback: @escaping () -> ()?) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        if let keyCombo = KeyCombo(key: .k, cocoaModifiers: [.command, .control]) {
            let hotKey = HotKey(identifier: "CommandControlK", keyCombo: keyCombo) { hotKey in
                print("invoked")
                callback()
            }
            hotKey.register()
        }
    }
}

#endif
