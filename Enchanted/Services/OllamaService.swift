//
//  OllamaService.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import Foundation
import OllamaKit

struct OllamaService {
    static var shared = OllamaService()
    
    static func reinit(url: String) {
        OllamaService.shared = OllamaService()
    }
    
    let ollamaKit: OllamaKit
    
    init() {
        var ollamaUrl = "http://localhost"
        if var endpoint = UserDefaults.standard.string(forKey: "ollamaUri") {
            if !endpoint.contains("http") {
                endpoint = "http://" + endpoint
            }
            ollamaUrl = endpoint
        }

        print("url", ollamaUrl)
        let url = URL(string: ollamaUrl)!
        ollamaKit =  OllamaKit(baseURL: url)
    }
    
    func getModels() async throws -> [LanguageModelSD]  {
        let response = try await ollamaKit.models()
        let models = response.models.map{model in LanguageModelSD(name: model.name)}
        return models
    }
    
    func reachable() async -> Bool {
        return await ollamaKit.reachable()
    }
    
    func chat(prompt: String, model: String) {}
}
