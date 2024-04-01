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
    var targetApplication: NSRunningApplication?
    var lastPrintApplication: NSRunningApplication?
    var panel: FloatingPanel!
    var completionsPanelVM = CompletionsPanelVM()
    @MainActor var allowPrinting = true
    let printer = Printer()
    
    override init() {
        super.init()
        
        Task {
            await NSApp.setActivationPolicy(.regular)
            await NSApp.activate(ignoringOtherApps: true)
            await handleNewMessages()
        }
    }
    
    private func handleNewMessages() async {
        let timer = AsyncTimerSequence(interval: .seconds(0.1), clock: .continuous)
        for await _ in timer {
            // If user focused different application stop writing
            if lastPrintApplication != nil && lastPrintApplication?.localizedName != NSWorkspace.shared.runningApplications.first(where: {$0.isActive})?.localizedName {
                continue
            }
            
            // hold printing until user action and ensuring that your driving experience
            if await !allowPrinting {
                continue
            }
            
            let sentencesToConsume = await completionsPanelVM.sentenceQueue.dequeueAll().joined()
            
            if sentencesToConsume.isEmpty {
                continue
            }
            
            print("printing: \((sentencesToConsume)) \(Date())")
            await printer.print(sentencesToConsume)
            lastPrintApplication = NSWorkspace.shared.runningApplications.first{$0.isActive}
        }
    }
    
    
    @MainActor
    @objc func togglePanel() {
        if panel == nil {
            Accessibility.shared.showAccessibilityInstructionsWindow()
        }
        
        targetApplication = NSWorkspace.shared.runningApplications.first{$0.isActive}

        Task {
            completionsPanelVM.selectedText = Accessibility.shared.getSelectedText()
            print("selected message", completionsPanelVM.selectedText as Any)
            
            if panel == nil || !panel.isVisible {
                showPanel()
                
                // subscribe to keybaord event to avoid beep
                HotkeyService.shared.registerSingleUseEscape(modifiers: []) { [weak self] in
                    self?.hidePanel()
                }
                
                return
            }
            
            hidePanel()
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
        allowPrinting = true
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
    @objc func onSubmitCompletion(scheduledTyping: Bool) {
        allowPrinting = true
        
        if scheduledTyping {
            self.allowPrinting = false
            HotkeyService.shared.registerSingleUseSpace(modifiers: []) { [weak self] in
                self?.allowPrinting = true
                self?.hidePanel()
            }
        } else {
            hidePanel()
        }
        targetApplication?.activate()
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
