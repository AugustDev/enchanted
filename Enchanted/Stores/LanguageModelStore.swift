//
//  ModelStore.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import Foundation
import SwiftData

@Observable
final class LanguageModelStore {
    private var swiftDataService: SwiftDataService
    var models: [LanguageModelSD] = []
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
    }
    
    @MainActor
    func loadModels() async throws {
        let localModels = try await loadLocal()
        let remoteModels = try await loadRemote()
    
        _ = localModels.map { model in
            model.isAvailable == remoteModels.contains(model)
        }
        
        let updateModelsList = Array(Set(localModels + remoteModels))
        try swiftDataService.saveModels(models: updateModelsList)
        
        models = try await loadLocal()
    }
    
    private func loadLocal() async throws -> [LanguageModelSD] {
        return try swiftDataService.fetchModels()
    }
    
    private func loadRemote() async throws -> [LanguageModelSD] {
        return try await OllamaService.shared.getModels()
    }
    
}
