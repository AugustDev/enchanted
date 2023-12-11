//
//  ConversationState.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import Foundation

enum ConversationState: Equatable {
    case loading
    case completed
    case error(message: String)
}
