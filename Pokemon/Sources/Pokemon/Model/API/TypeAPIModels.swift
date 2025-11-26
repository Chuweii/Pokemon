//
//  TypeAPIModels.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

// MARK: - Type List Response
public struct TypeListResponse: Decodable, Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [TypeListItem]
    
    public init(count: Int, next: String?, previous: String?, results: [TypeListItem]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public struct TypeListItem: Decodable, Sendable {
    public let name: String
    public let url: String

    public var id: Int? {
        // Extract ID from URL
        let cleanUrl = url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = cleanUrl.split(separator: "/")
        guard let lastComponent = components.last else { return nil }
        return Int(lastComponent)
    }
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
