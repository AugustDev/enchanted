//
//  UIImage+Extension.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 21/12/2023.
//

import SwiftUI

#if os(iOS) || os(visionOS)
extension UIImage {
    func convertImageToBase64String() -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func compressImageData() -> Data? {
        let resizedImage = self.aspectFittedToHeight(200)
        return resizedImage.jpegData(compressionQuality: 0.2)
    }
}
#elseif os(macOS)
extension NSImage {
    func convertImageToBase64String() -> String {
        guard let tiffRepresentation = self.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation),
              let jpegData = bitmapImage.representation(using: .jpeg, properties: [:]) else {
            return ""
        }
        return jpegData.base64EncodedString()
    }
    
    func aspectFittedToHeight(_ newHeight: CGFloat) -> NSImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = NSSize(width: newWidth, height: newHeight)
        
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        self.draw(in: NSRect(origin: .zero, size: newSize), from: NSRect(origin: .zero, size: self.size), operation: .copy, fraction: 1.0)
        newImage.unlockFocus()
        
        return newImage
    }
    
    func compressImageData() -> Data? {
        let resizedImage = self.aspectFittedToHeight(200)
        guard let tiffRepresentation = resizedImage.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }
        return bitmapImage.representation(using: .jpeg, properties: [.compressionFactor: 0.2])
    }
}
#endif
