//
//  ContactAPIService.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 17/11/25.
//

import Foundation
import SwiftUI
struct ContactRequest: Codable {
    let email: String
    let carbonCopy: String?
    let subject: String
    let description: String
    let userId: String?
}

struct ContactResponse: Codable {
    let message: String
    let contactId: String
}

import Foundation

final class ContactAPIService {

    static let shared = ContactAPIService()
    private init() {}

    // Read API base and key from Info.plist (recommended) with sensible defaults
    private let bundleBase = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
    private let bundleKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    private lazy var baseURL: URL = {
        let base = bundleBase ?? "http://localhost:5000"
        return URL(string: "\(base)/contact")!
    }()
    private lazy var apiKey: String = {
        return bundleKey ?? "test_api_key_123"
    }()

    func sendContact(request: ContactRequest) async throws -> ContactResponse {

        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"

        // Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        // Body
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("0000000 46 data: \(String(data:data,encoding: .utf8) ?? "")")
        print(" 47  -------- response: \(response)")

        // Validate HTTP response
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw NSError(domain: "ContactAPIService",
                          code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }

        return try JSONDecoder().decode(ContactResponse.self, from: data)
    }
}
