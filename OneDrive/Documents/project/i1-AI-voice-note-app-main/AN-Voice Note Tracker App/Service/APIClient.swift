//
//  APIClient.swift
//  AN-Voice Note Tracker App
//
//  Lightweight Swift async/await API client for the backend.
//  Drop this file into the project's Home/ViewModel folder and call
//  APIClient.shared from your view models or AIService.
//

import Foundation



final class APIClient {
    static let shared = APIClient()

    private let baseURL: URL
    private let apiKey: String
    var title = ""
    var summary = ""
    var action_items = [String]()
    init(baseURLString: String? = nil, apiKey: String? = nil) {
        // Try Info.plist first (recommended for config), otherwise use defaults
        let bundleBase = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
        print("23 bundleBase: \(bundleBase ?? "")")
        let bundleKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        print("25 bundleBase: \(bundleKey ?? "")")
        // Prefer the explicit initializer values -> Info.plist -> sensible defaults
        let base = baseURLString ?? bundleBase ?? "http://localhost:5000"
        guard let url = URL(string: base) else {
            // Fallback to localhost if malformed
            self.baseURL = URL(string: "http://localhost:5000")!
            print("APIClient: invalid base URL, falling back to http://localhost:5000")
            return
        }
        self.baseURL = url

        self.apiKey = apiKey ?? bundleKey ?? "test_api_key_123"
    }

    private func makeRequest(path: String) -> URLRequest {
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        req.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        if baseURL.host?.contains("ngrok") == true {
            // Required only when tunnelling through ngrok's free endpoints.
            req.setValue("1", forHTTPHeaderField: "ngrok-skip-browser-warning")
        }
        return req
    }

    // Upload audio file (multipart/form-data). Returns transcript string.
    func uploadAudio(fileUrl: URL) async throws -> String {
            print("🎧 uploadAudio called")

            var req = makeRequest(path: "upload")
            req.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            req.setValue("application/json", forHTTPHeaderField: "Accept")
            
            // ✅ Build multipart body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"audio\"; filename=\"recording.m4a\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(try Data(contentsOf: fileUrl))
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        req.httpBody = body
           
            
            let (data, response) = try await URLSession.shared.data(for: req)
            
            print("📩 Response: \(response)")
            print("📦 Data: \(String(data: data, encoding: .utf8) ?? "")")
            
            try validateResponse(response, data: data)
            
            let decoded = try JSONDecoder().decode(TranscriptResponse.self, from: data)
            print("✅ Decoded transcript: \(decoded.transcript)")
            
            return decoded.transcript
        }
        

//    func generateSummary(for transcript: String) async throws {
//        print("59 transcript: \(transcript)")
//        
//        guard let encoded = try? JSONEncoder().encode(["transcript": transcript]) else{
//            print("Failed to encode Transcript")
//            return
//        }
//        var req = makeRequest(path: "summary")
//        req.httpMethod = "POST"
//        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        req.httpBody = encoded
//        do{
//            let (data, resp) = try await URLSession.shared.data(for: req)
//            print("66 data and resp->  Data:\(String(data: data, encoding: .utf8) ?? "nil")  response: \(resp)")
//            let summaryResponse = try JSONDecoder().decode(SummaryResponse.self, from: data)
//            if let summaryTitle = summaryResponse.title,let transcriptSummary = summaryResponse.summary,let actionItems = summaryResponse.action_items{
//                title = summaryTitle
//                summary = transcriptSummary
//                action_items = actionItems
//            }
//        }catch{
//            print("generate Summary Failed: \(error.localizedDescription)")
//        }
//       
//       
//      
////        try validateResponse(resp, data: data)
//        
//    }

    func generateSummary(for transcript: String) async throws -> SummaryResponse {
        var req = makeRequest(path: "summary")
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(["transcript": transcript])

        
        let (data, resp) = try await URLSession.shared.data(for: req)
        
        try validateResponse(resp, data: data)
        return try JSONDecoder().decode(SummaryResponse.self, from: data)
    }
    
    
    func saveNote(title: String, transcript: String, correctedTranscript: String? = nil, summary: String, userId: String) async throws -> SaveNoteResponse {
        var req = makeRequest(path: "save-note")
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var body: [String: Any] = ["title": title, "transcript": transcript, "summary": summary, "userId": userId]
        if let corrected = correctedTranscript {
            body["corrected_transcript"] = corrected
        }
        req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, resp) = try await URLSession.shared.data(for: req)
        try validateResponse(resp, data: data)
        return try JSONDecoder().decode(SaveNoteResponse.self, from: data)
    }

    func getNotes(userId: String) async throws -> [NoteItem] {
        print("134 getNotes Called")
        var components = URLComponents(url: baseURL.appendingPathComponent("notes"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "userId", value: userId)]
        var req = URLRequest(url: components.url!)
        req.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        let (data, resp) = try await URLSession.shared.data(for: req)
        print("141 data: \(String(data:data,encoding: .utf8) ?? "")")
        try validateResponse(resp, data: data)
        print("143: \(try JSONDecoder().decode([NoteItem].self, from: data))")
        return try JSONDecoder().decode([NoteItem].self, from: data)
    }
    // delete note
    func deleteNote(noteId: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("note/\(noteId)")

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 200 {
            return true    // Note deleted successfully
        } else {
            return false   // No-op or error (Firestore no-op cases return 200/204)
        }
    }

    private func validateResponse(_ response: URLResponse, data: Data) throws {
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            // Attempt to decode error body
            if let errObj = try? JSONDecoder().decode([String: String].self, from: data), let msg = errObj["error"] ?? errObj["message"] {
                throw NSError(domain: "APIError", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])
            }
            throw NSError(domain: "APIError", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"])
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}





