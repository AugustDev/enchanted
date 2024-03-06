//
//  Accessibility.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 29/02/2024.
//

#if os(macOS)
import Foundation
import AppKit
import ApplicationServices
import CoreGraphics

actor Accessibility {
    static let shared = Accessibility()
    private var isBusy: Bool = false
    
    func getSelectedText() -> String? {
        if let text = getSelectedTextAX(), text.count > 1  {
            return text
        }
        
        return getSelectedTextViaCopy()
    }
    
    func getSelectedTextAX() -> String? {
        let systemWideElement = AXUIElementCreateSystemWide()
        
        var focusedApp: AnyObject?
        var error = AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedApplicationAttribute as CFString, &focusedApp)
        guard error == .success, let focusedAppElement = focusedApp as! AXUIElement? else { return nil }
        
        var focusedUIElement: AnyObject?
        error = AXUIElementCopyAttributeValue(focusedAppElement, kAXFocusedUIElementAttribute as CFString, &focusedUIElement)
        guard error == .success, let focusedElement = focusedUIElement as! AXUIElement? else { return nil }
        
        var selectedTextValue: AnyObject?
        error = AXUIElementCopyAttributeValue(focusedElement, kAXSelectedTextAttribute as CFString, &selectedTextValue)
        guard error == .success, let selectedText = selectedTextValue as? String else { return nil }
        
        return selectedText
    }
    
    
    func exploreAndRetrieveText(from element: AXUIElement) -> String? {
        print("Exporing")
        var parent: AXUIElement?
        var value: CFTypeRef?
        
        // Attempt to get the parent element
        // Explicitly cast `&parent` to the expected type using `withUnsafeMutablePointer`
        let error = withUnsafeMutablePointer(to: &parent) { pointer in
            // Cast the pointer's pointee to `UnsafeMutablePointer<CFTypeRef?>`
            // This is safe because AXUIElement is a type alias for CFTypeRef
            pointer.withMemoryRebound(to: CFTypeRef?.self, capacity: 1) { reboundPointer in
                AXUIElementCopyAttributeValue(element, kAXParentAttribute as CFString, reboundPointer)
            }
        }
        
        if error == .success, let parentElement = parent {
            // Try to get value (text) of the parent element
            AXUIElementCopyAttributeValue(parentElement, kAXValueAttribute as CFString, &value)
            
            if let textValue = value as? String, !textValue.isEmpty {
                return textValue
            } else {
                // Recursively explore up the hierarchy if the current parent doesn't have text
                return exploreAndRetrieveText(from: parentElement)
            }
        }
        return nil
    }

    
    func getSelectedTextA() -> String? {
        guard let window = NSWorkspace.shared.runningApplications.first(where: { $0.isActive }) else {
            print("Failed to find an active application.")
            return nil
        }
        
        guard let axWindow = AXUIElementCreateApplication(window.processIdentifier) as AXUIElement? else {
            print("Failed to create an AXUIElement for the active application.")
            return nil
        }

        var focusedElement: AnyObject?
        let errorFocusedElement = AXUIElementCopyAttributeValue(axWindow, kAXFocusedUIElementAttribute as CFString, &focusedElement)
        
        if errorFocusedElement != .success {
            print("Failed to get the focused UI element due to error: \(errorFocusedElement)")
            return nil
        }
        
        guard let axFocusedElement = focusedElement as! AXUIElement? else {
            print("Failed to cast focused UI element to AXUIElement.")
            return nil
        }

        // Attempt to retrieve the selected text from the focused UI element
        var selectedTextValue: AnyObject?
        AXUIElementCopyAttributeValue(axFocusedElement, kAXSelectedTextAttribute as CFString, &selectedTextValue)
        
        if let selectedText = selectedTextValue as? String, !selectedText.isEmpty {
            return selectedText
        } else {
            // If selected text is not available or is empty, explore parent elements for text
            return exploreAndRetrieveText(from: axFocusedElement)
        }
    }
    
    func getSelectedText3() -> String? {
        // Attempt to find the currently active application
        guard let window = NSWorkspace.shared.runningApplications.first(where: { $0.isActive }) else {
            print("Failed to find an active application.")
            return nil
        }
        
        // Access the accessibility element representing the window of the active application
        guard let axWindow = AXUIElementCreateApplication(window.processIdentifier) as AXUIElement? else {
            print("Failed to create an AXUIElement for the active application.")
            return nil
        }

        // Attempt to get the focused UI element within the window
        var focusedElement: AnyObject?
        let errorFocusedElement = AXUIElementCopyAttributeValue(axWindow, kAXFocusedUIElementAttribute as CFString, &focusedElement)
        
        if errorFocusedElement != .success {
            print("Failed to get the focused UI element due to error: \(errorFocusedElement)")
            return nil
        }
        
        guard let axFocusedElement = focusedElement as! AXUIElement? else {
            print("Failed to cast focused UI element to AXUIElement.")
            return nil
        }

        // Attempt to retrieve the selected text from the focused UI element
        var selectedTextValue: AnyObject?
        let errorSelectedText = AXUIElementCopyAttributeValue(axFocusedElement, kAXSelectedTextAttribute as CFString, &selectedTextValue)
        
        if errorSelectedText == .success, let selectedText = selectedTextValue as? String {
            return selectedText
        } else {
            print("Failed to retrieve selected text. Error: \(errorSelectedText)")
            return nil
        }
    }
    
    /// This method gets text that user has selected using clipboard. This approach is hacky and requires some tricks to handle all situations.
    /// Consider this to be a temporary solution
//    func getSelectedTextViaCopy() -> String? {
//        let pasteboard = NSPasteboard.general
//        let originalContents = pasteboard.pasteboardItems?.compactMap { $0.string(forType: .string) } ?? []
//        pasteboard.clearContents()
//        usleep(100000)
//        simulateCopyKeyPress()
//        simulateCopyKeyPress()
//        usleep(50000)
//        
//        if let newContent = pasteboard.string(forType: .string), !newContent.isEmpty {
//            return newContent
//        } else {
//            pasteboard.clearContents()
//            for item in originalContents {
//                pasteboard.setString(item, forType: .string)
//            }
//        }
//        
//        return nil
//    }

    
    func getSelectedTextViaCopy(retryAttempts: Int = 1) -> String? {
        let pasteboard = NSPasteboard.general
        let originalContents = pasteboard.pasteboardItems?.compactMap { $0.string(forType: .string) } ?? []
        pasteboard.clearContents()
        var attempts = 0
        var newContent: String?

        while attempts < retryAttempts && newContent == nil {
            simulateCopyKeyPress()
            usleep(100000)

            newContent = pasteboard.string(forType: .string)
            if let newContent = newContent, !newContent.isEmpty {
                break
            } else {
                newContent = nil
            }
            attempts += 1
        }

        if newContent == nil {
            pasteboard.clearContents()
            for item in originalContents {
                pasteboard.setString(item, forType: .string)
            }
        }

        return newContent
    }
    
    func simulateCopyKeyPress() {
        let source = CGEventSource(stateID: .hidSystemState)
        
        // Define the virtual keycode for 'C' and the command modifier
        let commandKey = CGEventFlags.maskCommand.rawValue
        let cKeyCode = CGKeyCode(8)  // Virtual keycode for 'C'
        
        // Create and post a key down event
        if let commandCDown = CGEvent(keyboardEventSource: source, virtualKey: cKeyCode, keyDown: true) {
            commandCDown.flags = CGEventFlags(rawValue: commandKey)
            commandCDown.post(tap: .cghidEventTap)
        }
        
        // Create and post a key up event
        if let commandCUp = CGEvent(keyboardEventSource: source, virtualKey: cKeyCode, keyDown: false) {
            commandCUp.flags = CGEventFlags(rawValue: commandKey)
            commandCUp.post(tap: .cghidEventTap)
        }
    }
    
    
    func simulateTyping(for string: String) {
        let source = CGEventSource(stateID: .combinedSessionState)
        let utf16Chars = Array(string.utf16)
        
        utf16Chars.forEach { uniChar in
            var uniChar = uniChar
            if uniChar == 0x000A {
                
                if let shiftDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(0x38), keyDown: true) {
                     shiftDown.post(tap: .cghidEventTap)
                 }
                 
                 // Simulate pressing and releasing the Return key
                 if let eventDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(0x24), keyDown: true),
                    let eventUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(0x24), keyDown: false) {
                     
                     eventDown.post(tap: .cghidEventTap)
                     Thread.sleep(forTimeInterval: 0.005)
                     eventUp.post(tap: .cghidEventTap)
                 }
                 
                 // Simulate releasing the Shift key
                 if let shiftUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(0x38), keyDown: false) {
                     shiftUp.post(tap: .cghidEventTap)
                 }
                
            } else {
                // Handle other characters as before
                if let eventDown = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true),
                   let eventUp = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false) {
                    
                    eventDown.keyboardSetUnicodeString(stringLength: 1, unicodeString: &uniChar)
                    eventUp.keyboardSetUnicodeString(stringLength: 1, unicodeString: &uniChar)
                    
                    eventDown.post(tap: .cghidEventTap)
                    Thread.sleep(forTimeInterval: 0.005)
                    eventUp.post(tap: .cghidEventTap)
                }
            }
        }
    }
    
    static func simulatePasteCommand() {
        let commandKey = CGEventFlags.maskCommand.rawValue
        let vKeyCode = 0x09
        let source = CGEventSource(stateID: .hidSystemState)
        if let commandVDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(vKeyCode), keyDown: true) {
            commandVDown.flags = CGEventFlags(rawValue: commandKey)
            commandVDown.post(tap: .cghidEventTap)
        }
        
        usleep(50000)
        
        if let commandVUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(vKeyCode), keyDown: false) {
            commandVUp.flags = CGEventFlags(rawValue: commandKey)
            commandVUp.post(tap: .cghidEventTap)
        }
    }
    

}
#endif
