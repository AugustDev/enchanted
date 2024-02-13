//
//  KeyboardReadable+Extension.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 13/02/2024.
//

import SwiftUI
import Combine

#if os(iOS)
/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
#elseif os(macOS)
/// Mock protocol
protocol KeyboardReadable {}
#endif
