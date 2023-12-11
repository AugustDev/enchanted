//
//  Message.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import Foundation

struct Message: Hashable {
    var prompt: String
    var response: String
    var done = false
    var error = false
    var createdAt = Date.now
    var model: LanguageModel?
}

extension Message {
    static let sample: [Message] = [
        .init(prompt: "How many quarks there are in SM?", response: "There are 6 quarks in SM, each of them has an antiparticle and colour."),
        .init(prompt: "How elementary particle is defined in mathematics?", response: "Elementary particle is defined as an irreducible representation of the poincase group.")
    ]
}
