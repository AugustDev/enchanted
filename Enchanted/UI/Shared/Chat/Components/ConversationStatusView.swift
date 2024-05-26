//
//  ConversationStatusView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/12/2023.
//

import SwiftUI
import ActivityIndicatorView

struct ConversationStatusView: View {
    var state: ConversationState
    var body: some View {
        switch state {
        case .loading: EmptyView()
        case .completed: EmptyView()
        case .error(let message): HStack {
            Text(message)
                .foregroundColor(.red)
                .font(.system(size: 16))
            Spacer()
        }
        }
        
    }
}

#Preview {
    Group {
        ConversationStatusView(state: .loading)
        ConversationStatusView(state: .completed)
        ConversationStatusView(state: .error(message: "Could not connect"))
    }.previewLayout(.sizeThatFits)
}
