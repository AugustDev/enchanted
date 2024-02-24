//
//  RetrievalStore.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 24/02/2024.
//

import Foundation

@Observable
final class RetrievalStore {
    private var swiftDataService: SwiftDataService
    static let shared = RetrievalStore(swiftDataService: SwiftDataService.shared)
    
    var databases: [DatabaseSD] = []
    var selectedDatabase: DatabaseSD?
    
    init(swiftDataService: SwiftDataService) {
        self.swiftDataService = swiftDataService
    }
    
    func createDatabase(name: String, indexPath: String) async throws {
        try await swiftDataService.createDatabase(name: name, indexPath: indexPath)
        try await getDatabases()
    }
    
    func getDatabases() async throws {
        databases = try await swiftDataService.getDatabases()
    }
}
