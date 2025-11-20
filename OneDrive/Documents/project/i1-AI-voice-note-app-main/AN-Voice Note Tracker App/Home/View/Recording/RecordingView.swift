//
//  RecordingView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import SwiftUI

struct RecordingView: View {
//    @State private var speechTimer = SpeechTimer()
    @Bindable var homeViewModel: HomeView.HomeViewModel
//    @State var speechTranscriber: SpokenWordTranscriber
    var body: some View {
        Group{
            VStack{
                Spacer()
                //Speaker View
                Button{
                    homeViewModel.handleRecordingButtonTap()
                    homeViewModel.speechTimer.stop()
                    withAnimation{
                        homeViewModel.showProgressView = true
                    }
                    
                    Task{
                        await homeViewModel.summaryResponseForTranscription()
                    }
                } label: {
                    if homeViewModel.isRecording {
                        SpeakerView()
                    }
               }
            //Microphone View
                Button{
                    homeViewModel.handleRecordingButtonTap()
                    homeViewModel.speechTimer.start()
                }label: {
                    if !homeViewModel.isRecording{
                        MicrophoneView()
                            .glassEffect()
                    }
                }
                Spacer()
               TimerView(homeViewModel: homeViewModel)

            }
        }
    }
}

//#Preview {
//    RecordingView()
//}
