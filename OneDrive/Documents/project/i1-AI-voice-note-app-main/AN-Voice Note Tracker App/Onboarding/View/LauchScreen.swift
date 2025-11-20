//
//  LauchScreen.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 31/10/25.
//

import SwiftUI

struct LauchScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height // start completely below screen
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            // Background based on system theme
            if colorScheme == .dark {
                Color.black.ignoresSafeArea()
            } else {
                Color.white.ignoresSafeArea()
            }

            VStack(spacing: 20) {
                Image(systemName: "mic.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
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
                    offsetY = 0      // move from bottom to center
                    opacity = 1.0    // fade in
                }
            }
        }
    }
}

#Preview {
    LauchScreen()
}
