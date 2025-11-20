//
//  TimerView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import SwiftUI

struct TimerView: View {
    @Bindable var homeViewModel: HomeView.HomeViewModel
    var body: some View {
        Group{
            Text(homeViewModel.formatTime(homeViewModel.speechTimer.elapsed))
                          .font(.system(size: 24, design: .monospaced))
        }
    }
}

//#Preview {
//    TimerView()
//}
