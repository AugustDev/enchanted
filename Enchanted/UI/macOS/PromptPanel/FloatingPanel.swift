//
//  PromptPanel.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

import SwiftUI

#if os(macOS)
class FloatingPanel: NSPanel {
    override func sendEvent(_ event: NSEvent) {
        super.sendEvent(event)
        
        // Check for left mouse down events
        if event.type == .leftMouseDown {
            let eventLocation = event.locationInWindow
            let localLocation = self.contentView?.convert(eventLocation, from: nil) ?? NSPoint.zero
            let isInside = self.contentView?.bounds.contains(localLocation) ?? false
            
            // If the click is outside the panel, close it
            if !isInside {
                self.orderOut(nil)
            }
        }
    }
    
    init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView], backing: backing, defer: flag)
        self.isFloatingPanel = true
        self.level = .floating
        self.collectionBehavior.insert(.fullScreenAuxiliary)
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.hasShadow = true
        self.contentView?.wantsLayer = true
        self.contentView?.layer?.masksToBounds = true
        self.isMovableByWindowBackground = true
        self.isReleasedWhenClosed = false
        //self.hidesOnDeactivate = true
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    // `canBecomeKey` and `canBecomeMain` are required so that text inputs inside the panel can receive focus
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}
#endif
