//
//  Model.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import Foundation

struct LanguageModel: Identifiable, Hashable {
    var id: String
    var name: String
    var version: String?
    var size: String?
}

extension LanguageModel {
    static var sample: [LanguageModel] = [
        .init(id: "1", name: "Mistral", version: "1"),
        .init(id: "2", name: "Llama2", version: "1")
    ]
}
