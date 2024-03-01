//
//  Clipboard.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/02/2024.
//

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
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
    
    func getImage() -> PlatformImage? {
        #if os(iOS)
        if let image = UIPasteboard.general.image {
            return image
        }
#elseif os(macOS)
        let pb = NSPasteboard.general
        let type = NSPasteboard.PasteboardType.tiff
        guard let imgData = pb.data(forType: type) else { return nil }
        return NSImage(data: imgData)
#endif
    }
    
    func getText() -> String? {
#if os(iOS)
        return UIPasteboard.general.string
#elseif os(macOS)
        return NSPasteboard.general.string(forType: .string)
#endif
    }
}


