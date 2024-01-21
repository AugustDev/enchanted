//
//  SettingsSectionView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 21/01/2024.
//

import SwiftUI

struct MyView<Content: View>: View {
    let content: [Content]

    init(@ViewBuilder content: () -> [Content]) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(content.enumerated()), id: \.offset) { index, element in
                if index < content.count - 1 {
                    element
                } else {
                    element
                }
            }
        }
    }
}

struct SettingsSectionView<Content: View>: View {
    private let content: [Content]
    private let title: String
    
    init(_ title: String, @ViewBuilder content: () -> [Content]) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .foregroundStyle(Color(.systemGray))
                    .font(.system(size: 12))
                
                Spacer()
                
            }
            VStack {
                ForEach(0..<content.count, id: \.self) { index in
                    content[index]
                    
                    if index < content.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    MyView {
               Text("a")
               Text("b")
               Button("Click Me") {}
           }
}
