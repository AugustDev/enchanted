//
//  Conversation.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import Foundation

struct Conversation: Identifiable {
    var id: UUID = UUID()
    var title: String = ""
    var messages: [Message] = []
    var createdAt: Date = Date.now
    var updatedAt: Date = Date.now
    var model: LanguageModel?
    var context: [Int] = []
}

extension Conversation {
    static let sample: [Conversation] = [
        .init(title: "What is your name?", messages: Message.sample, model: LanguageModel.sample[0])
    ]
}
