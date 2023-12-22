//
//  View+Extension.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 21/12/2023.
//

import SwiftUI

extension View {
    /// Whether the view should be empty.
    /// - Parameter bool: Set to `true` to show the view (return EmptyView instead).
    func showIf(_ bool: Bool) -> some View {
        modifier(ConditionalView(show: [bool]))
    }
    
    /// returns a original view only if all conditions are true
    func showIf(_ conditions: Bool...) -> some View {
        modifier(ConditionalView(show: conditions))
    }
}

struct ConditionalView: ViewModifier {
    
    let show: [Bool]
    
    func body(content: Content) -> some View {
        Group {
            if show.filter({ $0 == false }).count == 0 {
                content
            } else {
                EmptyView()
            }
        }
    }
}


extension View {
    /// Usually you would pass  `@Environment(\.displayScale) var displayScale`
    @MainActor func render(scale displayScale: CGFloat = 1.0) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        
        renderer.scale = displayScale
        
        return renderer.uiImage
    }
}
