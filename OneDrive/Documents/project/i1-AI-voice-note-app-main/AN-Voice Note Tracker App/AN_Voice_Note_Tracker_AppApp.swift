//
//  AN_Voice_Note_Tracker_AppApp.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

import SwiftUI
import SwiftData

@main
struct AN_Voice_Note_Tracker_AppApp: App {
    @AppStorage("appTheme") var appTheme: AppTheme = .system
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    @State private var showPaywall: Bool = false
    var body: some Scene {
        WindowGroup {
        MainTabView()
                .preferredColorScheme(colorSchemeFor(appTheme))
                .onAppear {
                    // decide to show paywall immediately after onboarding
                        if hasCompletedOnboarding && !isPremiumUser {
                                showPaywall = true
                        }
                    }
                .fullScreenCover(isPresented: $showPaywall) {
                        PaywallView(isPresented: $showPaywall)
                    }
        }
        .modelContainer(for: Notes.self)
    }
    
    private func colorSchemeFor(_ theme: AppTheme) -> ColorScheme? {
        switch theme {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
}
