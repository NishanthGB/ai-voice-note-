//
//  HomeView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

import SwiftUI
import TimerKit
import AVFoundation
import TranscriptionKit
import StoreKit
struct HomeView: View {
    
    @State var homeViewModel = HomeView.HomeViewModel()
//    @AppStorage("notesCount") var notesCount = 0

    var body: some View {
        NavigationStack{
            VStack{
                HeaderView(homeViewModel: homeViewModel)
                if homeViewModel.showProgressView && !homeViewModel.showTranscript{
                  ProgressViewUI(homeViewModel: homeViewModel)
                       
                }else if homeViewModel.showProgressView && homeViewModel.showTranscript{
                   TranscriptionView(homeViewModel: homeViewModel)

               }else{
                   RecordingView(homeViewModel: homeViewModel)
                  }
            }
            .padding(.vertical)
            
        }

        .onChange(of: homeViewModel.isRecording) { oldValue, newValue in
            guard newValue != oldValue else { return }
            if newValue == true {
                Task{
                    await homeViewModel.startRecording()
                }
            } else {
                Task{
                    await homeViewModel.stopRecording()
                }
                
            }
        }
    }
}

#Preview {
    HomeView()
}

