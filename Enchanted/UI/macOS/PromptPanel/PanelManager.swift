//
//  PanelManager.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

#if os(macOS)
import SwiftUI
import Carbon
import AsyncAlgorithms

final actor Printer {
    func print(_ message: String) {
        Clipboard.shared.setString(message)
        usleep(50000)
        Accessibility.simulatePasteCommand()
    }
}

class PanelManager: NSObject, NSApplicationDelegate {
    var lastRunningApplication: NSRunningApplication?
    var panel: FloatingPanel!
    var completionsPanelVM = CompletionsPanelVM()
    let printer = Printer()
    
    override init() {
        super.init()
        
        Task {
            await handleNewMessages()
        }
    }
    
    private func handleNewMessages() async {
        let timer = AsyncTimerSequence(interval: .seconds(0.1), clock: .suspending)
        for await _ in timer {
            let sentencesToConsume = await completionsPanelVM.sentenceQueue.dequeueAll().joined()
            
            if sentencesToConsume.isEmpty {
                continue
            }
            
            print("printing: \(sentencesToConsume)")
//            await Accessibility.shared.simulateTyping(for: sentencesToConsume)
            await printer.print(sentencesToConsume)
//            await Accessibility.shared.appleScript(for: sentencesToConsume)
        }
    }
    
    func getIsAuthorized() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false, ]
        return AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
    
    func checkAuth() {
        if getIsAuthorized() {
            print("it's authorised")
        } else {
            print("not auth")
        }
    }
    
    func checkAccessibilityPermission() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            DispatchQueue.main.async {
                // Show a window or alert with detailed instructions
                self.showAccessibilityInstructionsWindow()
            }
        }
    }
    
    @MainActor
    func showAccessibilityInstructionsWindow() {
        // Implement the function to show a window or alert with instructions on how to enable Accessibility permissions
        // This could be a simple NSAlert with a message and a button that opens System Preferences at the correct pane
        let alert = NSAlert()
        alert.messageText = "Accessibility Permission Needed"
        alert.informativeText = "Please grant Accessibility permissions to [Your App Name] via System Preferences > Security & Privacy > Privacy > Accessibility."
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    func requestAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !accessEnabled {
            print("Requesting Accessibility permissions...")
        }
    }
    
    
    @MainActor
    @objc func togglePanel() {
        lastRunningApplication = NSWorkspace.shared.runningApplications.first{$0.isActive}

        Task {
            completionsPanelVM.selectedText = await Accessibility.shared.getSelectedTextViaCopy()
            print(completionsPanelVM.selectedText)
            
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
    }
    
    @MainActor
    @objc func hidePanel() {
        panel.orderOut(nil)
    }
    
    @MainActor
    @objc func showPanel() {
        createPanel()
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @MainActor
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
    
    @MainActor
    @objc func onSubmitCompletion() {
        hidePanel()
        lastRunningApplication?.activate()
    }

    @MainActor
    func createPanel() {
        let contentView = PromptPanel(
            completionsPanelVM: completionsPanelVM,
            onSubmitPanel: onSubmitMessage,
            onSubmitCompletion: onSubmitCompletion,
            onLayoutUpdate: updatePanelSizeIfNeeded
        )
        let hostingView = NSHostingView(rootView: contentView)
        let idealSize = hostingView.fittingSize
        
        panel = FloatingPanel(
            contentRect: NSRect(x: 0, y: 0, width: idealSize.width, height: idealSize.height),
            backing: .buffered,
            defer: false
        )
        panel.contentView = hostingView
        panel.backgroundColor = .clear
        panel.center()
        panel.orderFront(nil)
    }
    
    @MainActor func updatePanelSizeIfNeeded() {
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
    @MainActor func windowDidResignKey(_ notification: Notification) {
        if let panel = notification.object as? FloatingPanel, panel == self.panel {
            panel.close()
        }
    }
}
#endif
