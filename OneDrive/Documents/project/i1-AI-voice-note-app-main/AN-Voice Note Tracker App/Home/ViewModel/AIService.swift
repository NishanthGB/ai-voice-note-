//
//  AIService.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 20/10/25.
//

import Foundation
import SwiftUI
struct AIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

@Observable
class AIService {
    static let shared = AIService()
    private let apiKey = "YOUR_OPENAI_API_KEY"
    
    func generateSummary(for text: String) async -> String {
        guard !text.isEmpty else { return "No text to summarize." }
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return "Invalid URL." }
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "Summarize the given text into key points in a concise note format."],
                ["role": "user", "content": text]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(AIResponse.self, from: data)
            return response.choices.first?.message.content ?? "No summary found."
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}
