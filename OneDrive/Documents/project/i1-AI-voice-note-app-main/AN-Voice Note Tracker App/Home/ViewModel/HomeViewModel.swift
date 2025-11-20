//
//  HomeViewModel.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import Foundation
import AVFoundation
import SwiftUI
extension HomeView{
    @Observable
    class HomeViewModel{
        
        //SpeechTranscriber
//        var story: Story
        
        var speechTranscriber: SpokenWordTranscriber
        var recorder: Recorder
        var speechTimer = SpeechTimer()
        var notesCount = 0
        var isRecording = false
        var isPlaying = false
        var showDiscard = false
        var downloadProgress = 0.0
        var currentPlaybackTime = 0.0
        var showProgressView = false
        var saveNoteResponseAlert = false
        //notes Detail
        var aiSummary = ""
        var title = ""
        var summary = ""
        var saveResponseAlertMessage = "Note Saved Successfully"
        var showTranscript = false
        var transcript = ""
        // The backend-corrected transcript (if returned by /summary)
        var correctedTranscript = ""
        var showRetry = false
        init() {
            // Initialize stored properties in a safe order without using `self` before init completes
            var story = Story(title: "", text: "")
            // Create local temporaries first
            let transcriber = SpokenWordTranscriber(story: .constant(story))
            let recorder = Recorder(transcriber: transcriber, story: .constant(story))

            // Assign to properties after locals are created
            self.speechTranscriber = transcriber
            self.recorder = recorder
        }
        
        //cancel Trnascription Discard
        func cancelTranscriptionDiscard(){
            withAnimation{
                showDiscard = false
            }
        }
        //showDiscardAlert
        func showDiscardAlert(){
            withAnimation{
                showDiscard = true
            }
        }
        //delete Transcription Discard
        func deleteTranscriptionDiscard(){
            withAnimation{
                title = ""
                summary = ""
                showTranscript = false
                showProgressView = false
            }
        }
        
        //save Response
        func saveNoteResponseSuccessFull(){
            withAnimation{
                showProgressView = false
                showTranscript = false
                speechTranscriber.finalizedTranscript = ""
                speechTranscriber.volatileTranscript = ""
            }
        }
        
        //Recording functions
        func startRecording() async{
            do {
                try await recorder.record()
            } catch {
                print("could not record: \(error)")
            }
        }
        
        func stopRecording() async{
            do {
                try await recorder.stopRecording()
            } catch {
                print("could not stop recording: \(error)")
            }
        }
        
       
        // summaryResponse
        func summaryResponseForTranscription() async {
            print("101 summaryResponseForTranscription")
            showProgressView = true
            showRetry = false

            do {
                let finalized = String(speechTranscriber.finalizedTranscript.characters)
                let volatile = String(speechTranscriber.volatileTranscript.characters)
                transcript = finalized + volatile
                
                print("96 transcript: \(transcript)")
                
                // ⬇️ APPLY TIMEOUT HERE (15 seconds recommended)
                let summaryResponse: SummaryResponse = try await withTimeout(10) {
                    try await AIServiceHelper.shared.generateSummary(for: self.transcript)
                }
                
                print("98 summaryResponse: \(summaryResponse)")
                
                if let summaryTitle = summaryResponse.title,
                   let summaryDescription = summaryResponse.summary {
                    
                    await MainActor.run {
                        title = summaryTitle
                        summary = summaryDescription
                        // Prefer corrected transcript from backend when available
                        if let corrected = summaryResponse.corrected_transcript {
                            correctedTranscript = corrected
                            transcript = corrected
                        }
                        showTranscript = true
                    }
                }
                
            } catch {
                // This catches BOTH:
                // 1) API error
                // 2) Timeout error
                await MainActor.run {
                    print("Timeout or failure occurred → showRetry = true")
                    showRetry = true
                }
            }
        }

        //Retry Summary Request
        func retrySummaryRequest() async {
            showRetry = false
            showProgressView = true

            do {
                let summaryResponse: SummaryResponse = try await withTimeout(10) {
                    try await AIServiceHelper.shared.generateSummary(for: self.transcript)
                }

                if let summaryTitle = summaryResponse.title,
                   let summaryDescription = summaryResponse.summary {
                    await MainActor.run {
                        title = summaryTitle
                        summary = summaryDescription
                        if let corrected = summaryResponse.corrected_transcript {
                            correctedTranscript = corrected
                            transcript = corrected
                        }
                        showTranscript = true
                    }
                }

            } catch {
                await MainActor.run {
                    print("Retry failed or timed out → showRetry = true")
                    showRetry = true
                }
            }
        }

        //save Note Response
        func saveNoteResponse() async {
            do{
                let saveNoteResponse = try await AIServiceHelper.shared.saveNote(title: title, transcript: transcript, correctedTranscript: correctedTranscript.isEmpty ? nil : correctedTranscript, summary: summary, userId: "tester")
                if saveNoteResponse.message != nil{
                 saveNoteResponseAlert = true
                }
                print("121 saveNoteResponse: \(saveNoteResponse)")
            }catch{
                print("Error: \(error.localizedDescription)")
            }
        }
        
        func handleRecordingButtonTap() {
            isRecording.toggle()
        }
        func handlePlayButtonTap() {
            isPlaying.toggle()
        }
        
        func formatTime(_ interval: TimeInterval) -> String {
                let seconds = Int(interval) % 60
                let minutes = Int(interval) / 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
//        func handlePlayback() {
//            guard story.url != nil else {
//                return
//            }
//            
//            if isPlaying {
//                recorder.playRecording()
////                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
////                    currentPlaybackTime = recorder.playerNode?.currentTime ?? 0.0
////                }
//            } else {
//                recorder.stopPlaying()
//                currentPlaybackTime = 0.0
////                timer = nil
//            }
//        }
        
       //Heightlight texted
        func shouldBeHighlighted(attributedStringRun: AttributedString.Runs.Run) -> Bool {
            guard isPlaying else { return false }
            let start = attributedStringRun.audioTimeRange?.start.seconds
            let end = attributedStringRun.audioTimeRange?.end.seconds
            guard let start, let end else {
                return false
            }
            
            if end < currentPlaybackTime { return false }
            
            if start < currentPlaybackTime, currentPlaybackTime < end {
                return true
            }
            
            return false
        }
        func attributedStringWithCurrentValueHighlighted(attributedString: AttributedString) -> AttributedString {
            var copy = attributedString
            copy.runs.forEach { run in
                if shouldBeHighlighted(attributedStringRun: run) {
                    let range = run.range
                    copy[range].backgroundColor = .mint.opacity(0.2)
                }
            }
            return copy
        }
    }
}

