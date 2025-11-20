//
//  WithTimeOut.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 17/11/25.
//

import Foundation
import SwiftUI
func withTimeout<T>(_ seconds: Double, operation: @escaping () async throws -> T) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        
        // Primary API call
        group.addTask {
            try await operation()
        }
        
        // Timeout task
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw URLError(.timedOut)
        }
        
        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}
