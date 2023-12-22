//
//  UIImage+Extension.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 21/12/2023.
//

import SwiftUI

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
