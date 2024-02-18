//
//  ConversationSD.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import Foundation
import SwiftData

@Model
final class ConversationSD: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    
    var name: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .nullify)
    var model: LanguageModelSD?

    @Relationship(deleteRule: .cascade, inverse: \MessageSD.conversation)
    var messages: [MessageSD] = []
    
    init(name: String, updatedAt: Date = Date.now) {
        self.name = name
        self.updatedAt = updatedAt
        self.createdAt = updatedAt
    }
}

extension ConversationSD {
    static let sample = [
        ConversationSD(name: "New Chat", updatedAt: Date.now),
        ConversationSD(name: "Presidential", updatedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!),
        ConversationSD(name: "What is QFT?", updatedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!)
    ]
}

// MARK: - @unchecked Sendable
extension ConversationSD: @unchecked Sendable {
    /// We hide compiler warnings for concurency. We have to make sure to modify the data only via SwiftDataManager to ensure concurrent operations.
}
