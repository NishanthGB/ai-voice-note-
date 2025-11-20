//
//  MainTabView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var selectedTabBar = 0
    @State var story = Story(title: "", text: "")
//    @State var showTabView = false
    var body: some View {
        Group{
            if hasCompletedOnboarding{
                TabView(selection: $selectedTabBar){
                    Tab("Home",systemImage: "house", value: 0){
                        HomeView()
                    }
                    Tab("Notes",systemImage: "text.document.fill", value: 1){
                        AllNotesUI()
                    }
                    Tab("Settings",systemImage: "gear",value: 2){
                        SettingView()
                    }
                }
                .tint(.themecolor)
            }else{
//                SplashScreenView(showTabView: $showTabView)
//                SplashScreenView()
                OnboardingView()
            }
            
        }
    }
    
}

#Preview {
    MainTabView()
}
