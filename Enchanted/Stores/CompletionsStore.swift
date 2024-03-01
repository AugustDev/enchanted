//
//  CompletionsStore.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 01/03/2024.
//

import Foundation
import SwiftUI

@Observable
final class CompletionsStore {
    static let shared = CompletionsStore(swiftDataService: SwiftDataService.shared)
    private var swiftDataService: SwiftDataService
    
    var completions: [CompletionInstructionSD] = []
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
        load()
    }
    
    func save() {
        Task {
            try? await swiftDataService.updateCompletionInstructions(completions)
        }
    }
    
    func delete(_ completion: CompletionInstructionSD) {
        Task {
            try? await swiftDataService.deleteCompletionInstruction(completion)
        }
    }
    
    func load() {
        Task {
            var loadedCompletions: [CompletionInstructionSD] = []
            loadedCompletions = (try? await SwiftDataService.shared.fetchCompletionInstructions()) ?? []
            
            if loadedCompletions.count == 0 {
                try? await SwiftDataService.shared.updateCompletionInstructions(CompletionInstructionSD.samples)
                loadedCompletions = (try? await SwiftDataService.shared.fetchCompletionInstructions()) ?? []
            }
            
            withAnimation {
                completions = loadedCompletions
            }
        }
    }
}
