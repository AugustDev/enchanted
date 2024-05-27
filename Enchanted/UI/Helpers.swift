//
//  Helpers.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/02/2024.
//

import SwiftUI

#if os(iOS) || os(visionOS)
typealias PlatformImage = UIImage
#else
typealias PlatformImage = NSImage
#endif

//Image(nsImage: nsImage)
