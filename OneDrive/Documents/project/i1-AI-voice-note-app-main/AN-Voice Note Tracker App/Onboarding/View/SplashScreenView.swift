//
//  SplashScreenView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

import SwiftUI

struct SplashScreenView: View {
//   @Binding var showTabView: Bool
    @State var showMainTabView: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State private var isActive = false
     @State private var opacity = 0.0
     @State private var scale: CGFloat = 0.8
    @State private var animationAmount: CGFloat = 1.0
    @State private var animate = false
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height // start completely below screen
    var body: some View {
        if isActive  && showMainTabView{
//            OnboardingUI(showTabView: $showTabView)
            OnboardingUI()
        }else if isActive {
               GeometryReader { geo in
                   Color(UIColor.systemBackground)
                               .overlay(
                                   Circle()
                                       .fill(Color.themecolor!)
                                       .frame(width: animate ? max(geo.size.width, geo.size.height) * 2 : 0,
                                              height: animate ? max(geo.size.width, geo.size.height) * 2 : 0)
                                       .animation(.easeInOut(duration: 2.0), value: animate)
                               )
                               .onAppear {
                                   animate = true
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                       withAnimation(.easeOut(duration: 1)) {
                                           self.showMainTabView = true
                                       }
                                   }
                               }
                       }
                       .ignoresSafeArea()
           }
        else {
            ZStack {
                // Background based on system theme
                if colorScheme == .dark {
                    Color.black.ignoresSafeArea()
                } else {
                    Color.white.ignoresSafeArea()
                }
           
                VStack(spacing: 20) {
                    Image("OnboardingLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.themecolor)
           
                    HStack {
                        Text("AI Voice")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.themecolor)
                        Text("Note")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .opacity(opacity)
                .offset(y: offsetY)
                .onAppear {
                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 15).delay(0.1)) {
                        offsetY = -200.0      // move from bottom to center
                        opacity = 1.0    // fade in
                    }
                }
            }
               .onAppear {
                   // After 2 seconds, navigate to MainTabView
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                       withAnimation(.easeOut(duration: 1)) {
                           self.isActive = true
                           animationAmount = 5
                       }
                   }
               }
           }
       }
}

//#Preview {
//    SplashScreenView()
//}
