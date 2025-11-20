//
//  Notes.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 27/10/25.
//

import Foundation
import SwiftUI
import SwiftData


@Model
class Notes:Identifiable,Hashable{
    var id: UUID
    var date: Date
    var notesTitle: String?
    var transcript: String?
    var aiSummary: [String]?
    init(id: UUID, date: Date,notesTitle: String?, transcript: String? = nil, aiSummary: [String]? = nil) {
        self.id = id
        self.date = date
        self.notesTitle = notesTitle
        self.transcript = transcript
        self.aiSummary = []
    }
}
