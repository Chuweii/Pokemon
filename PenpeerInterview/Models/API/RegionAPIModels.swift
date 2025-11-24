//
//  RegionAPIModels.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

// MARK: - Region List Response
struct RegionListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RegionListItem]
}

struct RegionListItem: Decodable {
    let name: String
    let url: String

    var id: Int? {
        // Extract ID from URL
        let components = url.split(separator: "/")
        guard let lastComponent = components.dropLast().last else { return nil }
        return Int(lastComponent)
    }
}

// MARK: - Region Detail Response
struct RegionDetailResponse: Decodable {
    let id: Int
    let name: String
    let locations: [LocationInfo]
}

struct LocationInfo: Decodable {
    let name: String
    let url: String
}
