//
//  OllamaService.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import Foundation
import OllamaKit

struct OllamaService {
    static var shared = OllamaService(url: "http://localhost:11434")
    
    static func reinit(url: String) {
        OllamaService.shared = .init(url: url)
    }
    
    let ollamaKit: OllamaKit
    
    init(url: String) {
        ollamaKit =  OllamaKit(baseURL: URL(string: url)!)
    }
    
    func getModels() async throws -> [LanguageModelSD]  {
        let response = try await ollamaKit.models()
        let models = response.models.map{model in LanguageModelSD(name: model.name)}
        return models
    }
    
    func chat(prompt: String, model: String) {}
}
