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
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    var isReachable: Bool = true

    init() {
        startCheckingReachability()
    }
    
    deinit {
        stopCheckingReachability()
    }
    
    private func startCheckingReachability(interval: TimeInterval = 10.0) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            Task { [weak self] in
                let status = await self?.reachable() ?? false
                self?.updateReachable(status)
            }
        }
    }
    
    func checkReachability() {
//        Task { [weak self] in
//            
//        }
    }
    
    private func updateReachable(_ isReachable: Bool) {
        withAnimation {
            self.isReachable = isReachable
        }
    }

    private func stopCheckingReachability() {
        timer?.invalidate()
        timer = nil
    }

    private func reachable() async -> Bool {
        return await OllamaService.shared.reachable()
    }
}
