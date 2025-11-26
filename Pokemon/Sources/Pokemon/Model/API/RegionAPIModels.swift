//
//  RegionAPIModels.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

// MARK: - Region List Response
public struct RegionListResponse: Decodable, Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [RegionListItem]
    
    public init(count: Int, next: String?, previous: String?, results: [RegionListItem]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public struct RegionListItem: Decodable, Sendable {
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

// MARK: - Region Detail Response
public struct RegionDetailResponse: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let locations: [LocationInfo]
    
    public init(id: Int, name: String, locations: [LocationInfo]) {
        self.id = id
        self.name = name
        self.locations = locations
    }
}

public struct LocationInfo: Decodable, Sendable {
    public let name: String
    public let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
