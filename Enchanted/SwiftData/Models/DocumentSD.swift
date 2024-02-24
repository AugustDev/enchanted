//
//  DocumentSD.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 24/02/2024.
//

import Foundation
import SwiftData

@Model
final class DocumentSD: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    
    var documentPath: String
    var updatedAt: Date
    var status: DocumentIndexStatus

    @Relationship(deleteRule: .nullify)
    var database: DatabaseSD?
    
    init(updatedAt: Date = Date.now, documentPath: String, status: DocumentIndexStatus) {
        self.updatedAt = updatedAt
        self.documentPath = documentPath
        self.status = status
    }
}

// MARK: - Sample
extension DocumentSD {
    static let sample = [
        DocumentSD(documentPath: "./files/company_house.pdf", status: .completed),
        DocumentSD(documentPath: "./files/notes.pdf", status: .indexing),
        DocumentSD(documentPath: "./files/important.pdf", status: .completed)
    ]
}


// MARK: - @unchecked Sendable
extension DocumentSD: @unchecked Sendable {
    /// We hide compiler warnings for concurency. We have to make sure to modify the data only via `SwiftDataManager` to ensure concurrent operations.
}
