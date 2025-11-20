//
//  AIService.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 05/11/25.
//


import Foundation
import SwiftUI
// API Response Models
struct TranscriptionResponse: Codable {
    let transcript: String
}

//struct SummaryResponse: Codable {
//    let title: String
//    let summary: String
//    let action_items: [String]
//}

@Observable
class AIServiceHelper {
    static let shared = AIServiceHelper()

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    /// Upload an audio file and return the transcript text.
    func uploadAudioAndTranscribe(audioURL: URL) async throws -> String {
        try await client.uploadAudio(fileUrl: audioURL)
    }

    /// Generate a structured summary payload for the provided transcript.
    func generateSummary(for text: String) async throws -> SummaryResponse {
        try await client.generateSummary(for: text)
    }
//
    /// Convenience helper that formats the summary response into a display string.
    func generateSummaryText(for text: String) async -> String {
        do {
            let response = try await generateSummary(for: text)
            let items = response.action_items.isEmpty ? "None" : response.action_items.enumerated().map { "• \($0.element)" }.joined(separator: "\n")
            return """
            Title: \(response.title ?? "")

            Summary:
            \(response.summary ?? "")

            Action Items:
            \(items)
            """
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }

    /// Save a note to the backend using the shared client.
    func saveNote(title: String, transcript: String, correctedTranscript: String? = nil, summary: String, userId: String) async throws -> SaveNoteResponse {
        try await client.saveNote(title: title, transcript: transcript, correctedTranscript: correctedTranscript, summary: summary, userId: userId)
    }

    /// Fetch all notes for the given user.
    func getNotes(userId: String) async throws -> [NoteItem] {
        try await client.getNotes(userId: userId)
    }
}
