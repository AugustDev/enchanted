//
//  AppStore.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 11/12/2023.
//

import Foundation
import Combine
import SwiftUI

@Observable
final class AppStore {
    static let shared = AppStore()
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    @MainActor var isReachable: Bool = true

    init() {
        startCheckingReachability()
    }
    
    deinit {
        stopCheckingReachability()
    }
    
    private func startCheckingReachability(interval: TimeInterval = 5) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            Task { [weak self] in
                let status = await self?.reachable() ?? false
                self?.updateReachable(status)
            }
        }
    }
    
    private func updateReachable(_ isReachable: Bool) {
        DispatchQueue.main.async {
            withAnimation {
                self.isReachable = isReachable
            }
        }
    }

    private func stopCheckingReachability() {
        timer?.invalidate()
        timer = nil
    }

    private func reachable() async -> Bool {
        let status = await OllamaService.shared.reachable()
        return status
    }
}
