//
//  Helpers.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/02/2024.
//

import SwiftUI

#if os(iOS)
typealias PlatformImage = UIImage
#elseif os(macOS)
typealias PlatformImage = NSImage
#endif
