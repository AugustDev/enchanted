//
//  Date.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import Foundation

extension Date {
    func daysAgoString() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: self, to: now)
        
        guard let daysAgo = components.day else {
            return "Today"
        }
        
        switch daysAgo {
        case 0:
            return "Today"
        case 1:
            return "1 day ago"
        default:
            return "\(daysAgo) days ago"
        }
    }
}
