//
//  PanelManager.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

#if os(macOS)
import SwiftUI

class PanelManager: NSObject, NSApplicationDelegate {
    var panel: FloatingPanel!
    
    override init() {
        super.init()
    }
    
    @objc func togglePanel() {
        if panel == nil {
            showPanel()
            return
        }
        
        if panel.isVisible {
            hidePanel()
        } else {
            showPanel()
        }
    }
    
    @objc func hidePanel() {
        panel.orderOut(nil)
    }
    
    @objc func showPanel() {
        createPanel()
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func onSubmitMessage() {
        hidePanel()
        
        /// Focus Enchanted
        if let app = NSRunningApplication.runningApplications(withBundleIdentifier: Bundle.main.bundleIdentifier!).first {
            app.activate(options: [.activateAllWindows])
            
            NSApp.windows.forEach { window in
                if window.isMiniaturized {
                    window.deminiaturize(nil)
                }
            }
        }
    }
    
    func createPanel() {
        let contentView = PromptPanel(onSubmitPanel: onSubmitMessage, onLayoutUpdate: updatePanelSizeIfNeeded)
        let hostingView = NSHostingView(rootView: contentView)
        
        let idealSize = hostingView.fittingSize
        
        panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: idealSize.width, height: idealSize.height), backing: .buffered, defer: false)
        panel.contentView = hostingView
        panel.backgroundColor = .clear
        panel.center()
        panel.orderFront(nil)
    }
    
    func updatePanelSizeIfNeeded() {
        guard let hostingView = panel.contentView as? NSHostingView<PromptPanel> else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let newSize = hostingView.fittingSize
            
            if newSize == .zero {
                return
            }
            
            if strongSelf.panel.frame.size != newSize {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.2
                    context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                    
                    // Calculate the difference in height
                    let heightDifference = newSize.height - strongSelf.panel.frame.size.height
                    
                    // Adjust the y position to keep the bottom edge constant
                    let newY = strongSelf.panel.frame.origin.y - heightDifference
                    
                    strongSelf.panel.animator().setFrame(
                        NSRect(x: strongSelf.panel.frame.origin.x,
                               y: newY, // Use the new Y
                               width: newSize.width,
                               height: newSize.height),
                        display: true)
                }, completionHandler: {
                    print("Animation completed")
                })
            }
        }
    }
}

extension PanelManager {
    func windowDidResignKey(_ notification: Notification) {
        if let panel = notification.object as? FloatingPanel, panel == self.panel {
            panel.close()
        }
    }
}
#endif
