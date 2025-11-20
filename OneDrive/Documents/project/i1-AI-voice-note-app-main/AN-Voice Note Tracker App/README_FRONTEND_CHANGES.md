Frontend changes and integration guide

This file documents the frontend changes applied to connect the iOS app with the updated backend. It includes before/after snippets so the iOS developer can review or revert changes.

Files changed
- `Service/APIClient.swift` — send `corrected_transcript` when saving notes.
- `Service/APIClientModel.swift` — (already updated) added `corrected_transcript` to `SummaryResponse`.
- `Service/AIServiceHelper.swift` — propagate `correctedTranscript` parameter to saveNote.
- `Home/ViewModel/HomeViewModel.swift` — track `correctedTranscript` and include it when saving notes.

1) `Service/APIClient.swift`

Old code:

```swift
func saveNote(title: String, transcript: String, summary: String, userId: String) async throws -> SaveNoteResponse {
    var req = makeRequest(path: "save-note")
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = ["title": title, "transcript": transcript, "summary": summary, "userId": userId]
    req.httpBody = try JSONEncoder().encode(body)

    let (data, resp) = try await URLSession.shared.data(for: req)
    try validateResponse(resp, data: data)
    return try JSONDecoder().decode(SaveNoteResponse.self, from: data)
}
```

New code:

```swift
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
```

2) `Service/AIServiceHelper.swift`

Old code:

```swift
func saveNote(title: String, transcript: String, summary: String, userId: String) async throws -> SaveNoteResponse {
    try await client.saveNote(title: title, transcript: transcript, summary: summary, userId: userId)
}
```

New code:

```swift
func saveNote(title: String, transcript: String, correctedTranscript: String? = nil, summary: String, userId: String) async throws -> SaveNoteResponse {
    try await client.saveNote(title: title, transcript: transcript, correctedTranscript: correctedTranscript, summary: summary, userId: userId)
}
```

3) `Home/ViewModel/HomeViewModel.swift`

Old code snippets (before changes):

```swift
var transcript = ""
// ...
func summaryResponseForTranscription() async {
    // after calling generateSummary
    if let summaryTitle = summaryResponse.title,
       let summaryDescription = summaryResponse.summary {
        await MainActor.run {
            title = summaryTitle
            summary = summaryDescription
            showTranscript = true
        }
    }
}

func saveNoteResponse() async {
    let saveNoteResponse = try await AIServiceHelper.shared.saveNote(title:title, transcript: transcript, summary: summary, userId: "tester")
}
```

New code snippets (after changes):

```swift
var transcript = ""
var correctedTranscript = ""
// ...
func summaryResponseForTranscription() async {
    // after calling generateSummary
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
}

func saveNoteResponse() async {
    let saveNoteResponse = try await AIServiceHelper.shared.saveNote(title: title, transcript: transcript, correctedTranscript: correctedTranscript.isEmpty ? nil : correctedTranscript, summary: summary, userId: "tester")
}
```

Notes
- These frontend edits are minimal and backward compatible. If you prefer not to modify the iOS project, the backend accepts `transcript` only; `corrected_transcript` is optional. However, including `corrected_transcript` when saving preserves the cleaned text.

If you want, I can revert any of these frontend edits. Otherwise the project is wired: the iOS app can call `/summary` and `/save-note` with `x-api-key` and the backend will store both raw and corrected transcripts.
