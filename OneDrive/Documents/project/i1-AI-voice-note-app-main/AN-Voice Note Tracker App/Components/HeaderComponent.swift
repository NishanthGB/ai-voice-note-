//
//  HeaderComponent.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 27/10/25.
//

import SwiftUI

struct HeaderComponent: View {
    @Environment(\.colorScheme) var colorScheme
    let appStoreURL = URL(string: "https://appstoreconnect.apple.com/teams/23b1f68c-3a00-450b-a504-d13c05bdda86/apps/6754606631/testflight/ios")!
    let title: String
    var body: some View {
        HStack{
            Text(title)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .fontWeight(.bold)
            Spacer()
            ShareLink(item: appStoreURL,preview: SharePreview("Check out my app!",image: Image("AppIcon"))){
//                Label("", systemImage: "square.and.arrow.up")
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(.title)
                    .padding(10)
                    .glassEffect()
////                        .clipShape(.circle)
//                        .glassEffect(.regular.tint(.gray.opacity(0.2)).interactive(),in: .circle)
//                       
            }
//            .foregroundStyle(colorScheme == .dark ? .white : .gray)
//                .fontWeight(.bold)
           
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    HeaderComponent(title: "Ai Voice Note")
}
