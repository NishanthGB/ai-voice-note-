//
//  SpeakerView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import SwiftUI

struct SpeakerView: View {
    @State var audio = AudioLevelManager()
    var body: some View {
        ZStack {

                   // ✅ Animated Outer Pulse (Google Translate style)
                   Circle()
                       .strokeBorder(Color.themecolor!, lineWidth: 3)
                       .frame(width: 80 + CGFloat(audio.level * 70),
                              height: 80 + CGFloat(audio.level * 70))
                       .animation(.easeOut(duration: 0.12), value: audio.level)

                   // ✅ Your Mic UI (Unchanged)
                   Image(systemName: "rectangle.fill")
                       .foregroundStyle(.white)
                       .padding()
                       .clipShape(.circle)
                       .padding()
                       .overlay {
                           Circle()
                               .strokeBorder(.white, style: StrokeStyle(lineWidth: 4))
                       }
                       .clipShape(.circle)
                       .padding()
                       .background(Color.themecolor)
                       .clipShape(.circle)
               }
               .onAppear {
                   audio.start()
               }
    }
}

#Preview {
    SpeakerView()
}
