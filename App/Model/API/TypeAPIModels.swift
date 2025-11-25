//
//  TypeAPIModels.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

// MARK: - Type List Response
struct TypeListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [TypeListItem]
}

struct TypeListItem: Decodable {
    let name: String
    let url: String

    var id: Int? {
        // Extract ID from URL
        let cleanUrl = url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = cleanUrl.split(separator: "/")
        guard let lastComponent = components.last else { return nil }
        return Int(lastComponent)
    }
}
