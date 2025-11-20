//
//  MicrophoneView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import SwiftUI

struct MicrophoneView: View {
    var body: some View {
       
        ZStack{
            Circle()
                   .frame(width: 168, height: 168)
                   .glassEffect()

            Circle()
                .frame(width:130,height:130)
                .foregroundStyle(Color.themecolor ?? Color.yellow)
            Image(systemName: "microphone.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 63.55, height: 78)
                .foregroundStyle(.white)
        }
      
//        .background(Color.themecolor!)
//        .clipShape(.circle)
//        .padding(30)
//        .glassEffect(in: .circle)
    }
}

#Preview {
    MicrophoneView()
}
