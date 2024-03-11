//
//  ConversationHistoryList.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import SwiftUI

struct ConversationGroup: Hashable {
    let date: Date
    var conversations: [ConversationSD]
    
    // Implementing the Hashable protocol
    static func == (lhs: ConversationGroup, rhs: ConversationGroup) -> Bool {
        lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}

struct ConversationHistoryList: View {
    var conversations: [ConversationSD]
    var onTap: (_ conversation: ConversationSD) -> ()
    var onDelete: (_ conversation: ConversationSD) -> ()
    var onDeleteDailyConversations: (_ date: Date) -> ()
    
    func groupConversationsByDay(conversations: [ConversationSD]) -> [ConversationGroup] {
        let groupedDictionary = Dictionary(grouping: conversations) { (conversation) -> Date in
            return Calendar.current.startOfDay(for: conversation.updatedAt)
        }
        
        return groupedDictionary.map { (key, value) in
            ConversationGroup(date: key, conversations: value)
        }.sorted(by: { $0.date > $1.date })
    }
    
    var conversationGroups: [ConversationGroup] {
        groupConversationsByDay(conversations: conversations)
    }
    
    var body: some View {
        List {
            ForEach(conversationGroups, id:\.self) { conversationGroup in
                
                HStack {
                    Text(conversationGroup.date.daysAgoString())
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemGray))
                    
                    Spacer()
                }
                .contextMenu(menuItems: {
                    Button(role: .destructive, action: { onDeleteDailyConversations(conversationGroup.date) }) {
                        Label("Delete daily conversations", systemImage: "trash")
                    }
                })
                
                ForEach(conversationGroup.conversations, id:\.self) { dailyConversation in
                    HStack {
                        Text(dailyConversation.name)
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                            .foregroundColor(Color(.label))
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .onTapGesture {
                        onTap(dailyConversation)
                    }
                    .buttonStyle(.plain)
                    .swipeActions {
                        Button(role: .destructive, action: { onDelete(dailyConversation) }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .contextMenu(menuItems: {
                        Button(role: .destructive, action: { onDelete(dailyConversation) }) {
                            Label("Delete", systemImage: "trash")
                        }
                    })
                }
                
                Divider()
            }
        }
    }
}


#Preview {
    ConversationHistoryList(conversations: ConversationSD.sample, onTap: {_ in}, onDelete: {_ in}, onDeleteDailyConversations: {_ in})
}
