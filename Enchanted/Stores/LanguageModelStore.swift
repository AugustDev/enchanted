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
    var supportsImages = false
    var selectedModel: LanguageModelSD?
    
    var imageModelNames = ["llava"]
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
    }
    
    @MainActor
    func setModel(model: LanguageModelSD?) {
        selectedModel = model
        
        checkModelFeatures()
    }
    
    func checkModelFeatures() {
        for modelName in imageModelNames {
            if let selectedModelName = selectedModel?.name {
                if selectedModelName.contains(modelName) {
                    supportsImages = true
                    return
                }
            }
        }
        
        supportsImages = false
    }
    
    @MainActor
    func loadModels() async throws {
        print("loading models")
        let localModels = try await loadLocal()
        let remoteModels = try await loadRemote()
    
        _ = localModels.map { model in
            model.isAvailable == remoteModels.contains(model)
        }
        
        let updateModelsList = Array(Set(localModels + remoteModels))
        try swiftDataService.saveModels(models: updateModelsList)
        
        models = try await loadLocal()
        print("loaded models")
    }
    
    private func loadLocal() async throws -> [LanguageModelSD] {
        return try swiftDataService.fetchModels()
    }
    
    private func loadRemote() async throws -> [LanguageModelSD] {
        return try await OllamaService.shared.getModels()
    }
    
}
