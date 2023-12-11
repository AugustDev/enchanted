//
//  SideBarMenuView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import SwiftUI

struct SideBarStack<SidebarContent: View, Content: View>: View {
    let sidebarContent: SidebarContent
    let mainContent: Content
    let sidebarWidth: CGFloat
    @State var offset: CGFloat = 0
    @Binding var showSidebar: Bool
    
    init(sidebarWidth: CGFloat, showSidebar: Binding<Bool>, @ViewBuilder sidebar: ()->SidebarContent, @ViewBuilder content: ()->Content) {
        self.mainContent = content()
        self.sidebarContent = sidebar()
        self.sidebarWidth = sidebarWidth
        self._showSidebar = showSidebar
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            sidebarContent
                .frame(width: sidebarWidth, alignment: .center)
                .offset(x: showSidebar ? offset - sidebarWidth : -sidebarWidth, y: 0)
                .gesture(DragGesture().onChanged({ gesture in
                    let t = gesture.translation.width
                    if t > 0 {
                        return
                    }
                    
                    withAnimation(.spring) {
                        offset = sidebarWidth + t
                    }
                }).onEnded({ gesture in
                    withAnimation(.spring) {
                        if -offset < 100 {
                            offset = 0
                        } else {
                            offset = sidebarWidth
                        }
                        showSidebar = false
                    }
                    
                }))
            mainContent
                .overlay(
                    Group {
                        if showSidebar {
                            Color(.systemGray)
                                .ignoresSafeArea()
                                .opacity(showSidebar ? (offset/sidebarWidth * 0.3) : 0.1)
                                .onTapGesture {
                                    withAnimation(.spring) {
                                        self.offset = 0
                                        self.showSidebar = false
                                    }
                                }
                        }
                    }
                )
                .offset(x: showSidebar ? offset : 0, y: 0)
            
        }
        .onChange(of: showSidebar) { oldValue, newValue in
            if newValue {
                withAnimation(.spring) {
                    offset = sidebarWidth
                }
            }
        }
    }
}
