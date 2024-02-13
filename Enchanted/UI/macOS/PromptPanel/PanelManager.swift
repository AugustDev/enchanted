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
            createPanel()
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
        let contentView = PromptPanel(onSubmitPanel: onSubmitMessage)
            .edgesIgnoringSafeArea(.all)
            .padding(.bottom, -28)
        
        panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 512, height: 80), backing: .buffered, defer: false)
        panel.title = "Floating Panel Title"
        panel.contentView = NSHostingView(rootView: contentView)
        panel.center()
        panel.orderFront(nil)
        panel.makeKey()
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
