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
    var models: [LanguageModelSD] = []
    var supportsImages = false
    var selectedModel: LanguageModelSD?
    
    private var imageModelNames = ["llava"]
    
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
        
        checkModelFeatures()
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
    
    func loadModels() async throws {
        print("loading models")
        let localModels = try await swiftDataService.fetchModels()
        print("completed loadLocal()")
        let remoteModels = try await OllamaService.shared.getModels()
        print("completed loadRemote()")
        
        _ = localModels.map { model in
            model.isAvailable == remoteModels.contains(model)
        }
        
        let updateModelsList = Array(Set(localModels + remoteModels))
        try await swiftDataService.saveModels(models: updateModelsList)
        print("completed saveModels()")
        
        models = try await swiftDataService.fetchModels()
        sleepTest("loadModels")
    }
    
    func deleteAllModels() async throws {
        models = []
        try await swiftDataService.deleteModels()
    }
}
