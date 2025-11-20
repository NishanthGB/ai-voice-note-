//
//  NoteItem.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 09/11/25.
//


import Foundation

@Observable
class NoteItem: Codable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _title = "title"
        case _transcript = "transcript"
        case _summary = "summary"
        case _userId = "userId"
        case _createdAt = "createdAt"
    }
    var id: String
    var title: String?
    var transcript: String?
    var summary: String?
    var userId: String?
    var createdAt: String?
        init(id: String, title: String? = nil, transcript: String? = nil, summary: String? = nil, userId: String? = nil, createdAt: String? = nil) {
        self.id = id
        self.title = title
        self.transcript = transcript
        self.summary = summary
        self.userId = userId
        self.createdAt = createdAt
    }
//    static var example =
//        NoteItem(id: "1", title: "Title", transcript: "Transcript", summary: "Summary", userId: "1", createdAt: "2025-11-03T12:34:56Z")

    // MARK: - Hashable & Equatable
    static func == (lhs: NoteItem, rhs: NoteItem) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
