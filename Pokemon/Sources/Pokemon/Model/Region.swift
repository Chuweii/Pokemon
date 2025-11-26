//
//  Region.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

public struct Region {
    public let id: Int
    public let name: String
    public let locationCount: Int

    public var capitalizedName: String {
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    public init(from response: RegionDetailResponse) {
        self.id = response.id
        self.name = response.name
        self.locationCount = response.locations.count
    }
}
