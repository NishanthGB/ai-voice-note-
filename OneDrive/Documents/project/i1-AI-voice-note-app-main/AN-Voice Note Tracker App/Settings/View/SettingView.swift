//
//  SettingView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - Header
                HeaderComponent(title: "Settings")
                   
                
                // MARK: - List Section
                SettingOptions()
                    .listStyle(.insetGrouped)
            }
            .padding(.vertical)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SettingView()
}
