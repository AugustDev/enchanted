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
    var selectedConversation: ConversationSD?
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
        VStack(alignment: .leading, spacing: 17) {
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
                    Button(action: {onTap(dailyConversation)}) {
                        HStack {
                            Circle()
                                .frame(width: 6, height: 6)
                                .animation(.easeOut(duration: 0.15))
                                .transition(.opacity)
                                .showIf(selectedConversation == dailyConversation)
                            
                            Text(dailyConversation.name)
                                .lineLimit(1)
                                .font(.system(size: 16))
                                .foregroundColor(Color(.label))
                                .animation(.easeOut(duration: 0.15))
                                .transition(.opacity)
                            Spacer()
                        }
                        .animation(.easeOut(duration: 0.15))
                    }
                    .buttonStyle(.plain)
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
    ConversationHistoryList(selectedConversation: ConversationSD.sample[0], conversations: ConversationSD.sample, onTap: {_ in}, onDelete: {_ in}, onDeleteDailyConversations: {_ in})
}
