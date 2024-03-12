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
            print(model)
            if model.name == modelName {
                setModel(model: model)
                return
            }
        }
    }
    
    func loadModels() async throws {
        let remoteModelNames = try await OllamaService.shared.getModels()
        try await swiftDataService.saveModels(models: remoteModelNames.map{LanguageModelSD(name: $0)})
        
        let storedModels = (try? await swiftDataService.fetchModels()) ?? []
        
        DispatchQueue.main.async {
            self.models = storedModels.filter{remoteModelNames.contains($0.name)}
        }
    }
    
    func deleteAllModels() async throws {
        DispatchQueue.main.async {
            self.models = []
        }
        try await swiftDataService.deleteModels()
    }
}
