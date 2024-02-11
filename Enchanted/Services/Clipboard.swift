//
//  Clipboard.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/02/2024.
//

import Foundation

#if os(macOS)
import AppKit
#endif


class Clipboard {
    static let shared = Clipboard()
    
    func setString(_ message: String) {
#if os(iOS)
        UIPasteboard.general.string = message
#elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(message, forType: .string)
#endif
    }
}
