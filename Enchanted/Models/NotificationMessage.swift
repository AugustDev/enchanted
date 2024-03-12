//
//  NotificationMessage.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/03/2024.
//

import Foundation

struct NotificationMessage: Identifiable {
    var id = UUID()
    var message: String
    var status: Status
    var timestamp = Date()
    
    enum Status {
        case error
        case info
    }
}

// MARK: Sample data
extension NotificationMessage {
    static let sample: [NotificationMessage] = [
        .init(message: "Querying ollama", status: .info),
        .init(message: "Window changed. Stopping writing.", status: .info)
    ]
}
