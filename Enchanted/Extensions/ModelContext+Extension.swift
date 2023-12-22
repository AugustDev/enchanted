//
//  ModelContext.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import Foundation
import SwiftData

extension ModelContext {
    func saveChanges() throws {
        if self.hasChanges {
            try self.save()
        }
    }
}
