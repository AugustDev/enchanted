//
//  ConversationSD.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import Foundation
import SwiftData

@Model
final class MessageSD: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    
    var prompt: String
    var response: String?
    var context: [Int]?
    var done: Bool = false
    var error: Bool = false
    var createdAt: Date = Date.now
    
    @Relationship var conversation: ConversationSD?
        
    init(prompt: String, response: String? = nil) {
        self.prompt = prompt
        self.response = response
    }
    
    @Transient var model: String {
        conversation?.model?.name ?? ""
    }
}

extension MessageSD {
    static let sample: [MessageSD] = [
        .init(prompt: "How many quarks there are in SM?", response: "There are 6 quarks in SM, each of them has an antiparticle and colour."),
        .init(prompt: "How elementary particle is defined in mathematics?", response: "Elementary particle is defined as an irreducible representation of the poincase group.")
    ]
}
