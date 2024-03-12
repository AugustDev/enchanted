//
//  MenuBarControl_macOS.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

#if os(macOS)
import SwiftUI

struct MenuBarControl: View {
    @State private var appStore = AppStore.shared
    var body: some View {
        MenuBarControlView(notifications: appStore.notifications)
    }
}
#endif
