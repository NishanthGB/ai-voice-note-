//
//  SpeechTimer.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 11/11/25.
//

import Foundation
import SwiftUI
import Combine

@Observable
final class SpeechTimer {
   var elapsed: TimeInterval = 0

    private var timer: AnyCancellable?
    private var startDate: Date?

    /// Call this when user starts speaking
    func start() {
        guard timer == nil else { return }   // prevent multiple timers

        startDate = Date()

        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let start = self.startDate else { return }
                self.elapsed = Date().timeIntervalSince(start)
            }
    }

    /// Call this when user stops speaking
    func stop() {
        timer?.cancel()
        timer = nil
    }

    /// Optional: reset timer if needed
    func reset() {
        elapsed = 0
        startDate = nil
    }
}
