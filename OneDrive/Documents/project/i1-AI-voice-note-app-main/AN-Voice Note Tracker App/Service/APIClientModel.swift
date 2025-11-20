//
//  APIClientModel.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 03/11/25.
//

import Foundation

struct TranscriptResponse: Codable {
    let transcript: String
}

struct SummaryResponse: Codable {
    let title: String?
    let summary: String?
    // corrected_transcript: populated by the backend when it cleans/corrects the transcript
    let corrected_transcript: String?
    let action_items: [String]
}

struct SaveNoteResponse: Codable {
    var message: String?
    var noteId: String?
}

//struct NoteItem: Codable,Identifiable,Hashable{
//    var id: String
//    var title: String?
//    var transcript: String?
//    var summary: String?
//    var userId: String?
//    var createdAt: String?
//    
//    static var example =
//        NoteItem(id: "1", title: "Title", transcript: "Transcript", summary: "Summary", userId: "1", createdAt: "2025-11-03T12:34:56Z")
//
//}
