//
//  OnboardingUI.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//
import SwiftUI

struct OnboardingUI: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
//    @Binding var showTabView: Bool
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    
                    // MARK: - Top Half (Image)
                    Image("OnboardingImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height / 1.8)
                        .clipped()
                    
                    // MARK: - Bottom Half (Rounded Card)
                    VStack(spacing: 25) {
                        Text("From Voice to Notes!")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 8) {
                            Text("No typing, no hassle.")
                            Text("Just speak and save your ideas in seconds.")
                                .multilineTextAlignment(.center)
                        }
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .fontWeight(.semibold)
                        .frame(width: 300)
                        
                        Button{
                            hasCompletedOnboarding = true
//                                showTabView.toggle()
                            
                        } label: {
                            Text("Start")
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 250, height: 50)
                                .glassEffect(colorScheme == .dark ?  .regular.tint(.white).interactive() : .regular.tint(.black).interactive() ,in: .capsule)
//                                .background(colorScheme == .dark ? .white : .black)
                               
//                                .clipShape(Capsule())
//                                .shadow(radius: 3)
//                                .padding(.bottom,100)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 1.8)
                    .background(
                        (colorScheme == .dark ? Color.black : Color.white)
                            .clipShape(
                                RoundedCornerShape(corners: [.topLeft, .topRight], radius: 35)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
                    )
                }
                .ignoresSafeArea(edges: .bottom)
                
                
            }
        }
    }
}

// MARK: - Custom Shape
struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

//#Preview {
//    OnboardingUI()
//}
