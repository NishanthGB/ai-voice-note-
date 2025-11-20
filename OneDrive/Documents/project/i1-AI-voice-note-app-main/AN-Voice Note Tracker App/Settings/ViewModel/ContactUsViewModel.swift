//
//  ContactUsViewModel.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 17/11/25.
//

import Foundation
import SwiftUI

extension SettingView{
    @Observable
    class ContactUsViewModel: Codable{
        enum CodingKeys: String, CodingKey{
            case _email = "email"
            case _carbonCopy = "carbonCopy"
            case _subject = "subject"
            case _description = "description"
            case _message = "message"
            case _userId = "userId"
        }
        var email = "support@inventoone.com"
        var carbonCopy = "user@gmail.com"
        var subject = "New Age Currency App Report"
        var description = "we want offline storage too"
        var message = ""
        var userId = "tester"
        func ContactUs() async {
                let requestBody = ContactRequest(email: email, carbonCopy: carbonCopy, subject: subject, description: description, userId: userId)
                do {
                    let resp = try await ContactAPIService.shared.sendContact(request: requestBody)
                    print("Contact sent, id: \(resp.contactId)")
                } catch {
                    print("Contact failed: \(error.localizedDescription)")
                }
        }
    }
}
