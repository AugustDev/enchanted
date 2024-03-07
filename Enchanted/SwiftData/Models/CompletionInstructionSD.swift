//
//  CompletionInstructionSD.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 29/02/2024.
//

import Foundation
import SwiftData

@Model
final class CompletionInstructionSD: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var keyboardCharacterStr: String
    var instruction: String
    var order: Int
    
    var keyboardCharacter: Character {
        keyboardCharacterStr.first ?? "x"
    }
    
    init(name: String, keyboardCharacterStr: String, instruction: String, order: Int) {
        self.name = name
        self.keyboardCharacterStr = keyboardCharacterStr
        self.instruction = instruction
        self.order = order
    }
}

// MARK: - Sample data
extension CompletionInstructionSD {
    static let samples: [CompletionInstructionSD] = [
        .init(name: "Fix Grammar", keyboardCharacterStr: "f", instruction: "Fix grammar for the text below", order: 1),
        .init(name: "Summarize", keyboardCharacterStr: "s", instruction: "Summarize the following text, focusing strictly on the key facts and core arguments. Exclude any model-generated politeness or introductory phrases. Provide a direct, concise summary.", order: 2),
        .init(name: "Write More", keyboardCharacterStr: "w", instruction: "Elaborate on the following content, providing additional insights, examples, detailed explanations, and related concepts. Dive deeper into the topic to offer a comprehensive understanding and explore various dimensions not covered in the original text.", order: 3),
        .init(name: "Politely Decline", keyboardCharacterStr: "d", instruction: "Write a response politely declining the offer below", order: 4)
    ]
}


// MARK: - @unchecked Sendable
extension CompletionInstructionSD: @unchecked Sendable {
    /// We hide compiler warnings for concurency. We have to make sure to modify the data only via SwiftDataManager to ensure concurrent operations.
}
