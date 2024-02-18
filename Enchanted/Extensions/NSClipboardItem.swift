//
//  NSPasteboardItem.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 17/02/2024.
//

#if os(macOS)
import Foundation
import AppKit

extension NSPasteboardItem {
    func image(forType type: NSPasteboard.PasteboardType) -> Data? {
        guard let tiffData = data(forType: type) else { return nil }
        let image = NSImage(data: tiffData)
        return image?.tiffRepresentation
    }
}
#endif
