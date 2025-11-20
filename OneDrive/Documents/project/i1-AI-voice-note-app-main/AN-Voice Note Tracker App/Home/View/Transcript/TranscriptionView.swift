//
//  TranscriptView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import SwiftUI
import StoreKit

struct TranscriptionView: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var homeViewModel : HomeView.HomeViewModel
//    @State var speechTranscriber: SpokenWordTranscriber
    @Environment(\.requestReview) var requestReview
    @State private var isEditingTitle = false
    var body: some View {
        Group{
            VStack{
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading, spacing: 20) {

                        if isEditingTitle {
                            TextField("Title", text: $homeViewModel.title, onCommit: {
                                isEditingTitle = false
                            })
                            .font(.title)
                            .bold()
                            .textFieldStyle(.plain)
                            .onDisappear { isEditingTitle = false }
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.sentences)
                        } else {
                            Text(homeViewModel.title.isEmpty ? "Title" : homeViewModel.title)
                                .font(.title)
                                .bold()
                                .foregroundColor(homeViewModel.title.isEmpty ? .gray : .primary)
                                .onTapGesture {
                                    isEditingTitle = true
                                }
                        }

                        liveRecordingView
                    }


//                     VStack(alignment: .leading,spacing:20){
////                         Text(homeViewModel.title)
////                             .font(.title)
////                             .bold()
//                         TextField("Enter title...", text: $homeViewModel.title)
//                                .font(.title)
//                                .bold()
//                                .textFieldStyle(.plain)      // removes default border
//                                .padding(.vertical, 4)
//                         liveRecordingView
//                     }
                 }
                .frame(maxHeight: .infinity)
                HStack{
                    Button{
                        homeViewModel.showDiscardAlert()
                    } label: {
                        DiscardButton()
                    }
                    Button{
                        Task{
                            await homeViewModel.saveNoteResponse()
                         
                        }
                        homeViewModel.notesCount += 1
                        if homeViewModel.notesCount >= 2{
                            requestReview()
                        }
                    } label: {
                        SaveButton()
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .padding(.horizontal)
            
        }
        .alert("Delete note?",isPresented: $homeViewModel.showDiscard){
            Button("Cancel"){
                homeViewModel.cancelTranscriptionDiscard()
            }
            Button("Delete"){
                homeViewModel.deleteTranscriptionDiscard()
            }
        }
        .alert("\(homeViewModel.saveResponseAlertMessage)",isPresented: $homeViewModel.saveNoteResponseAlert){
            Button("OK"){
                homeViewModel.saveNoteResponseSuccessFull()
            }
        }
    }
    @ViewBuilder
    var liveRecordingView: some View {
        Text(homeViewModel.speechTranscriber.finalizedTranscript + homeViewModel.speechTranscriber.volatileTranscript)
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    TranscriptionView()
//}
