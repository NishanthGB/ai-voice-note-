//
//  SettingOptions.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 27/10/25.
//

import SwiftUI
import StoreKit

struct SettingOptions: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Environment(\.requestReview) var requestReview
    @State private var selectDate = Date()
    @State private var darkMode = false
    @State private var showSheet = false
    let appStoreURL = URL(string: "https://appstoreconnect.apple.com/teams/23b1f68c-3a00-450b-a504-d13c05bdda86/apps/6754606631/testflight/ios")!
    var body: some View {
        List {
            // MARK: - Reminder
            HStack {
                Image(systemName: "bell")
                   
                DatePicker("Set Reminder", selection: $selectDate, displayedComponents: .hourAndMinute)
            }
            
            // MARK: - Rate Us
           Button{
                // Destination View (e.g., AppStore link or RateUsView)
               withAnimation{
                   requestReview()
               }
            } label: {
                HStack{
                    Image(systemName: "star.circle")
                    Text("Rate Us")
                }
                .foregroundStyle(colorScheme == .dark ? .white : .black)
//                Label("Rate Us", systemImage: "star.circle")
            }
            
            // MARK: - Share App

            ShareLink(item: appStoreURL,preview: SharePreview("Check out my app!",image: Image("AppIcon"))){
                HStack{
                    Image(systemName: "square.and.arrow.up")
                    Text("Share App")
                }
                .foregroundStyle(colorScheme == .dark ? .white : .black)
//                Label("Share App", systemImage: "square.and.arrow.up")
//                    .tint(.black)
            }
            
            // MARK: - App Icons
            NavigationLink {
               AppIconsUI()
            } label: {
                HStack{
                    Image(systemName: "circle.grid.2x2")
                    Text("App Icons")
                }
//                Label("App Icons", systemImage: "circle.grid.2x2")
            }
            
            // MARK: - Contact Support
            Button {
                showSheet = true
            } label: {
                HStack{
                    Image(systemName: "message")
                    Text("Contact Support")
                }
                .foregroundStyle(colorScheme == .dark ? .white : .black)
//                Label("Contact Support", systemImage: "message")
//                    .foregroundStyle(.primary)
            }
            
            // MARK: - Dark Mode
            Toggle(isOn: Binding(
                        get: { appTheme == .dark },
                        set: { appTheme = $0 ? .dark : .light }
            )){
                HStack{
                    Image(systemName: "moon.circle")
                    Text("Dark Mode")
                }
                .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
        }
        .scrollContentBackground(.hidden) // Removes white background from List
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showSheet) {
            ContactUs()
        }
    }
}

#Preview {
    SettingOptions()
}
