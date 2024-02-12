//
//  SamplePrompt.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/02/2024.
//

import Foundation

struct SamplePrompts: Identifiable, Hashable {
    enum SamplePromptType {
        case question
        case action
        
        var icon: String {
            switch self {
            case .question:
                return "questionmark.circle"
            case .action:
                return "lightbulb.circle"
            }
        }
    }
    
    var prompt: String
    var type: SamplePromptType
    
    var id: String {
        prompt
    }
}

// MARK: - Sample Data
extension SamplePrompts {
    static let samples: [SamplePrompts] = [
        .init(prompt: "Give me phrases to learn in a new language", type: .action),
        .init(prompt: "Act like Mowgli from The Jungle Book and answer questions", type: .action),
        .init(prompt: "How to center div in HTML?", type: .question),
        .init(prompt: "What's unique about Go programming language?", type: .question),
        .init(prompt: "Give 10 gift ideas for best friend", type: .action),
        .init(prompt: "How to do personal taxes in USA?", type: .question),
        .init(prompt: "What are the largest cities in USA in population? Give a table", type: .question)
    ]
    
    static var shuffled: [SamplePrompts] {
        return samples.shuffled()
    }
}
