//
//  BannerView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 27/10/25.
//

import SwiftUI

struct BannerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geo in
            // Banner height = 22% of screen width (scales nicely across all devices)
            let bannerHeight = geo.size.width * 0.38
            
            ZStack {
                
                // MARK: Gradient Background
                LinearGradient(
                    stops: [
                        .init(
                            color: Color(red: 252/255, green: 207/255, blue: 62/255, opacity: 0.5),
                            location: 0.057
                        ),
                        .init(
                            color: Color("#FCFCFE"),
                            location: 0.6758
                        ),
                        .init(
                            color: Color(red: 255/255, green: 204/255, blue: 0/255, opacity: 0.2),
                            location: 1.0
                        )
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: bannerHeight)
                .cornerRadius(20)
                
                HStack {
                    // MARK: Left Content
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Set a reminder for you next class or meeting")
                            .font(.system(size: 17))
                            .italic()
                            .lineLimit(2)
                            .frame(maxWidth: geo.size.width * 0.55, alignment: .leading)
                        
                        NavigationLink {
                            SettingView()
                        } label: {
                            ZStack {
                                Capsule()
//                                    .fill(.ultraThinMaterial)
                                    .fill(.ultraThinMaterial)
                                    .glassEffect()
                                    .frame(width: geo.size.width * 0.38,
                                           height: bannerHeight * 0.34)
                                
                                Text("Set Reminder")
                                    .foregroundStyle(Color(red: 64/255, green: 64/255, blue: 64/255))
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    // MARK: Right Image
                    Image("HomeImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.32,
                               height: bannerHeight * 0.8)
                        .padding(.trailing, 6)
                        .padding(.top,20)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 170)  // outer container height so GeometryReader works
    }
}

#Preview {
    BannerView()
}
