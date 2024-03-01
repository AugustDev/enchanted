//
//  HotKeys.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 17/02/2024.
//

#if os(macOS)
import Foundation
import SwiftUI
import Combine

@available(OSX 11.0, *)
extension View {
    func addCustomHotkeys( _ hotkeys: [HotkeyCombination] ) -> some View {
        self.modifier(HotKeysMod(hotkeys))
    }
}

@available(OSX 11.0, *)
public struct HotKeysMod: ViewModifier {
    @State var subs = Set<AnyCancellable>() // Cancel onDisappear
    var hotkeys: [HotkeyCombination]
    
    init(_ hotkeys: [HotkeyCombination] ) {
        self.hotkeys = hotkeys
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            DisableSoundsView(hotkeys:hotkeys)
                .frame(width: 1, height: 1)
            content
        }
    }
}

struct DisableSoundsView: NSViewRepresentable {
    var hotkeys: [HotkeyCombination]
    
    func makeNSView(context: Context) -> NSView {
        let view = DisableSoundsNSView()
        
        view.hotkeys = hotkeys
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}

class DisableSoundsNSView: NSView {
    var hotkeys: [HotkeyCombination] = []
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return hotkeysSubscription(combinations: hotkeys)
    }
}

fileprivate func hotkeysSubscription(combinations: [HotkeyCombination]) -> Bool {
    for comb in combinations {
        let basePressedCorrectly = comb.keyBasePressed
        
        if basePressedCorrectly && comb.key.isPressed {
            comb.action()
//            return true
        }
    }
    
    return false
}

///////////////////////
///HELPERS
///////////////////////
struct HotkeyCombination {
    let keyBase: [KeyBase]
    let key: CGKeyCode
    let action: () -> ()
}

extension HotkeyCombination {
    var keyBasePressed: Bool {
        let mustBePressed    = KeyBase.allCases.filter{ keyBase.contains($0) }
        let mustBeNotPressed = KeyBase.allCases.filter{ !keyBase.contains($0) }
        
        for base in mustBePressed {
            if !base.isPressed {
                return false
            }
        }
        
        for base in mustBeNotPressed {
            if base.isPressed {
                return false
            }
        }
        
        return true
    }
}

enum KeyBase: CaseIterable {
    case option
    case command
    case shift
    case control
    
    var isPressed: Bool {
        switch self {
        case .option:
            return CGKeyCode.kVK_Option.isPressed  || CGKeyCode.kVK_RightOption.isPressed
        case .command:
            return CGKeyCode.kVK_Command.isPressed || CGKeyCode.kVK_RightCommand.isPressed
        case .shift:
            return CGKeyCode.kVK_Shift.isPressed   || CGKeyCode.kVK_RightShift.isPressed
        case .control:
            return CGKeyCode.kVK_Control.isPressed || CGKeyCode.kVK_RightControl.isPressed
        }
    }
}

import Foundation

///https://gist.github.com/chipjarred/cbb324c797aec865918a8045c4b51d14
extension CGKeyCode {
    static let kVK_ANSI_A                    : CGKeyCode = 0x00
    static let kVK_ANSI_S                    : CGKeyCode = 0x01
    static let kVK_ANSI_D                    : CGKeyCode = 0x02
    static let kVK_ANSI_F                    : CGKeyCode = 0x03
    static let kVK_ANSI_H                    : CGKeyCode = 0x04
    static let kVK_ANSI_G                    : CGKeyCode = 0x05
    static let kVK_ANSI_Z                    : CGKeyCode = 0x06
    static let kVK_ANSI_X                    : CGKeyCode = 0x07
    static let kVK_ANSI_C                    : CGKeyCode = 0x08
    static let kVK_ANSI_V                    : CGKeyCode = 0x09
    static let kVK_ANSI_B                    : CGKeyCode = 0x0B
    static let kVK_ANSI_Q                    : CGKeyCode = 0x0C
    static let kVK_ANSI_W                    : CGKeyCode = 0x0D
    static let kVK_ANSI_E                    : CGKeyCode = 0x0E
    static let kVK_ANSI_R                    : CGKeyCode = 0x0F
    static let kVK_ANSI_Y                    : CGKeyCode = 0x10
    static let kVK_ANSI_T                    : CGKeyCode = 0x11
    static let kVK_ANSI_1                    : CGKeyCode = 0x12
    static let kVK_ANSI_2                    : CGKeyCode = 0x13
    static let kVK_ANSI_3                    : CGKeyCode = 0x14
    static let kVK_ANSI_4                    : CGKeyCode = 0x15
    static let kVK_ANSI_6                    : CGKeyCode = 0x16
    static let kVK_ANSI_5                    : CGKeyCode = 0x17
    static let kVK_ANSI_Equal                : CGKeyCode = 0x18
    static let kVK_ANSI_9                    : CGKeyCode = 0x19
    static let kVK_ANSI_7                    : CGKeyCode = 0x1A
    static let kVK_ANSI_Minus                : CGKeyCode = 0x1B
    static let kVK_ANSI_8                    : CGKeyCode = 0x1C
    static let kVK_ANSI_0                    : CGKeyCode = 0x1D
    static let kVK_ANSI_RightBracket         : CGKeyCode = 0x1E
    static let kVK_ANSI_O                    : CGKeyCode = 0x1F
    static let kVK_ANSI_U                    : CGKeyCode = 0x20
    static let kVK_ANSI_LeftBracket          : CGKeyCode = 0x21
    static let kVK_ANSI_I                    : CGKeyCode = 0x22
    static let kVK_ANSI_P                    : CGKeyCode = 0x23
    static let kVK_ANSI_L                    : CGKeyCode = 0x25
    static let kVK_ANSI_J                    : CGKeyCode = 0x26
    static let kVK_ANSI_Quote                : CGKeyCode = 0x27
    static let kVK_ANSI_K                    : CGKeyCode = 0x28
    static let kVK_ANSI_Semicolon            : CGKeyCode = 0x29
    static let kVK_ANSI_Backslash            : CGKeyCode = 0x2A
    static let kVK_ANSI_Comma                : CGKeyCode = 0x2B
    static let kVK_ANSI_Slash                : CGKeyCode = 0x2C
    static let kVK_ANSI_N                    : CGKeyCode = 0x2D
    static let kVK_ANSI_M                    : CGKeyCode = 0x2E
    static let kVK_ANSI_Period               : CGKeyCode = 0x2F
    static let kVK_ANSI_Grave                : CGKeyCode = 0x32
    static let kVK_ANSI_KeypadDecimal        : CGKeyCode = 0x41
    static let kVK_ANSI_KeypadMultiply       : CGKeyCode = 0x43
    static let kVK_ANSI_KeypadPlus           : CGKeyCode = 0x45
    static let kVK_ANSI_KeypadClear          : CGKeyCode = 0x47
    static let kVK_ANSI_KeypadDivide         : CGKeyCode = 0x4B
    static let kVK_ANSI_KeypadEnter          : CGKeyCode = 0x4C
    static let kVK_ANSI_KeypadMinus          : CGKeyCode = 0x4E
    static let kVK_ANSI_KeypadEquals         : CGKeyCode = 0x51
    static let kVK_ANSI_Keypad0              : CGKeyCode = 0x52
    static let kVK_ANSI_Keypad1              : CGKeyCode = 0x53
    static let kVK_ANSI_Keypad2              : CGKeyCode = 0x54
    static let kVK_ANSI_Keypad3              : CGKeyCode = 0x55
    static let kVK_ANSI_Keypad4              : CGKeyCode = 0x56
    static let kVK_ANSI_Keypad5              : CGKeyCode = 0x57
    static let kVK_ANSI_Keypad6              : CGKeyCode = 0x58
    static let kVK_ANSI_Keypad7              : CGKeyCode = 0x59
    static let kVK_ANSI_Keypad8              : CGKeyCode = 0x5B
    static let kVK_ANSI_Keypad9              : CGKeyCode = 0x5C

    // keycodes for keys that are independent of keyboard layout
    static let kVK_Return                    : CGKeyCode = 0x24
    static let kVK_Tab                       : CGKeyCode = 0x30
    static let kVK_Space                     : CGKeyCode = 0x31
    static let kVK_Delete                    : CGKeyCode = 0x33
    static let kVK_Escape                    : CGKeyCode = 0x35
    static let kVK_Command                   : CGKeyCode = 0x37
    static let kVK_Shift                     : CGKeyCode = 0x38
    static let kVK_CapsLock                  : CGKeyCode = 0x39
    static let kVK_Option                    : CGKeyCode = 0x3A
    static let kVK_Control                   : CGKeyCode = 0x3B
    static let kVK_RightCommand              : CGKeyCode = 0x36 // Out of order
    static let kVK_RightShift                : CGKeyCode = 0x3C
    static let kVK_RightOption               : CGKeyCode = 0x3D
    static let kVK_RightControl              : CGKeyCode = 0x3E
    static let kVK_Function                  : CGKeyCode = 0x3F
    static let kVK_F17                       : CGKeyCode = 0x40
    static let kVK_VolumeUp                  : CGKeyCode = 0x48
    static let kVK_VolumeDown                : CGKeyCode = 0x49
    static let kVK_Mute                      : CGKeyCode = 0x4A
    static let kVK_F18                       : CGKeyCode = 0x4F
    static let kVK_F19                       : CGKeyCode = 0x50
    static let kVK_F20                       : CGKeyCode = 0x5A
    static let kVK_F5                        : CGKeyCode = 0x60
    static let kVK_F6                        : CGKeyCode = 0x61
    static let kVK_F7                        : CGKeyCode = 0x62
    static let kVK_F3                        : CGKeyCode = 0x63
    static let kVK_F8                        : CGKeyCode = 0x64
    static let kVK_F9                        : CGKeyCode = 0x65
    static let kVK_F11                       : CGKeyCode = 0x67
    static let kVK_F13                       : CGKeyCode = 0x69
    static let kVK_F16                       : CGKeyCode = 0x6A
    static let kVK_F14                       : CGKeyCode = 0x6B
    static let kVK_F10                       : CGKeyCode = 0x6D
    static let kVK_F12                       : CGKeyCode = 0x6F
    static let kVK_F15                       : CGKeyCode = 0x71
    static let kVK_Help                      : CGKeyCode = 0x72
    static let kVK_Home                      : CGKeyCode = 0x73
    static let kVK_PageUp                    : CGKeyCode = 0x74
    static let kVK_ForwardDelete             : CGKeyCode = 0x75
    static let kVK_F4                        : CGKeyCode = 0x76
    static let kVK_End                       : CGKeyCode = 0x77
    static let kVK_F2                        : CGKeyCode = 0x78
    static let kVK_PageDown                  : CGKeyCode = 0x79
    static let kVK_F1                        : CGKeyCode = 0x7A
    static let kVK_LeftArrow                 : CGKeyCode = 0x7B
    static let kVK_RightArrow                : CGKeyCode = 0x7C
    static let kVK_DownArrow                 : CGKeyCode = 0x7D
    static let kVK_UpArrow                   : CGKeyCode = 0x7E

    // ISO keyboards only
    static let kVK_ISO_Section               : CGKeyCode = 0x0A

    // JIS keyboards only
    static let kVK_JIS_Yen                   : CGKeyCode = 0x5D
    static let kVK_JIS_Underscore            : CGKeyCode = 0x5E
    static let kVK_JIS_KeypadComma           : CGKeyCode = 0x5F
    static let kVK_JIS_Eisu                  : CGKeyCode = 0x66
    static let kVK_JIS_Kana                  : CGKeyCode = 0x68

    var isModifier: Bool {
        return (.kVK_RightCommand...(.kVK_Function)).contains(self)
    }

    var baseModifier: CGKeyCode?
    {
        if (.kVK_Command...(.kVK_Control)).contains(self)
                || self == .kVK_Function
        {
                return self
        }

        switch self
        {
                case .kVK_RightShift: return .kVK_Shift
                case .kVK_RightCommand: return .kVK_Command
                case .kVK_RightOption: return .kVK_Option
                case .kVK_RightControl: return .kVK_Control

                default: return nil
        }
    }
    
    var isPressed: Bool {
        CGEventSource.keyState(.combinedSessionState, key: self)
    }
}
#endif
