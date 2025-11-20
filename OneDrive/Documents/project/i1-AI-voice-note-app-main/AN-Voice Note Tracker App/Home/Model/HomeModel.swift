//
//  HomeModel.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

import Foundation
import ThemeKit
import SwiftData

@Model
class DailyScrum: Identifiable {
    var id: UUID
    var title: String
    
    init(id:UUID = UUID(),title: String){
        self.id = id
        self.title = title
    }
}
