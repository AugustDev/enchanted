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

actor Accessibility {
    static let shared = Accessibility()
    private var isBusy: Bool = false
    
    func getSelectedText() -> String? {
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
    
    func getSelectedTextViaCopy() -> String? {
        let pasteboard = NSPasteboard.general
        let originalContents = pasteboard.pasteboardItems?.compactMap { $0.string(forType: .string) } ?? []
        pasteboard.clearContents()
        
        simulateCopyKeyPress()
        usleep(50000)
        
        if let newContent = pasteboard.string(forType: .string), !newContent.isEmpty {
            return newContent
        } else {
            pasteboard.clearContents()
            for item in originalContents {
                pasteboard.setString(item, forType: .string)
            }
        }
        
        return nil
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

    
    
    func simulateTyping2(for string: String) {
        let source = CGEventSource(stateID: .combinedSessionState)
        let utf16Chars = Array(string.utf16)
        
        utf16Chars.forEach { uniChar in
            var uniChar = uniChar
            if let eventDown = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true),
               let eventUp = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false) {
                
                eventDown.keyboardSetUnicodeString(stringLength: 1, unicodeString: &uniChar)
                eventUp.keyboardSetUnicodeString(stringLength: 1, unicodeString: &uniChar)
                
                eventDown.post(tap: .cghidEventTap)
                Thread.sleep(forTimeInterval: 0.005)
                eventUp.post(tap: .cghidEventTap)
            }
        }
        
        
        // 1. Simulate keystrokes to inject the text
//        guard let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true) else { return }
//        keyDownEvent.flags = .maskCommand // Simulate Command key press
//
//        for character in string {
//            let utf16CodeUnit = UInt16(character.unicodeScalars.first!.value) // Force conversion
//            var codeUnit = utf16CodeUnit
//            keyDownEvent.keyboardSetUnicodeString(stringLength: 1, unicodeString: &codeUnit)
//            keyDownEvent.post(tap: .cghidEventTap)
//        }
//
//        // 2. Release Command Key
//        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false)
//        keyUpEvent?.flags = .maskCommand
//        keyUpEvent?.post(tap: .cghidEventTap)
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
    
    func appleScript(for string: String) async {
        
        while isBusy {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second
        }
        isBusy = true
        
        let escapedText = string.replacingOccurrences(of: "\"", with: "\\\"")
        
        // Split the text into lines
        let lines = escapedText.split(separator: "\n", omittingEmptySubsequences: false)
        
        // Build the AppleScript command to type each line and press Return after each, except the last one
        var scriptCommands = ""
        for (index, line) in lines.enumerated() {
            scriptCommands += "keystroke \"\(line)\""
            if index < lines.count - 1 {
                scriptCommands += "\nkeystroke return\n" // Simulate pressing the Return key for new lines
            }
        }
        
        let script = """
        tell application "System Events"
            \(scriptCommands)
        end tell
        """

        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            appleScript.executeAndReturnError(&error)
            if let error = error {
                print(error)
            }
        }
        
        isBusy = false
    }
}
#endif
