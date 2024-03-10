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
    static let shared = LanguageModelStore(swiftDataService: SwiftDataService.shared)
    
    private var swiftDataService: SwiftDataService
    @MainActor var models: [LanguageModelSD] = []
    @MainActor var supportsImages = false
    @MainActor var selectedModel: LanguageModelSD?
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
    }
    
    @MainActor
    func setModel(model: LanguageModelSD?) {
        if let model = model {
            // check if model still exists
            if models.contains(model) {
                selectedModel = model
            }
        } else {
            selectedModel = nil
        }
    }
    
    @MainActor
    func setModel(modelName: String) {
        for model in models {
            if model.name == modelName {
                setModel(model: model)
                return
            }
        }
    }
    
    func loadModels() async throws {
        print("loading models")
        let localModels = try await swiftDataService.fetchModels()
        print("completed loadLocal()")
        let remoteModels = try await OllamaService.shared.getModels()
        print("completed loadRemote()")
        print(remoteModels)
        
        _ = localModels.map { model in
            model.isAvailable == remoteModels.contains(model)
        }
        
        let updateModelsList = Array(Set(localModels + remoteModels))
        try await swiftDataService.saveModels(models: updateModelsList)
        print("completed saveModels()")
        
        let fetchedModels = try await swiftDataService.fetchModels()
        
        DispatchQueue.main.async {
            self.models = fetchedModels
        }
    }
    
    func deleteAllModels() async throws {
        DispatchQueue.main.async {
            self.models = []
        }
        try await swiftDataService.deleteModels()
    }
}
