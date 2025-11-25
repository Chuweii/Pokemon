//
//  Region.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

struct Region {
    let id: Int
    let name: String
    let locationCount: Int

    var capitalizedName: String {
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    init(from response: RegionDetailResponse) {
        self.id = response.id
        self.name = response.name
        self.locationCount = response.locations.count
    }
}
