//
//  Pokemon.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

public struct Pokemon {
    public let id: Int
    public let name: String
    public let types: [PokemonType]
    public let imageUrl: String?
    public let sprites: PokemonImageSprites?
    public var isFavorited: Bool

    public var formattedNumber: String {
        return "#\(id)"
    }

    public var capitalizedName: String {
        return name.uppercased()
    }

    // Convert from API Response
    public init(from response: PokemonDetailResponse, isFavorited: Bool = false) {
        self.id = response.id
        self.name = response.name
        self.types = response.types.map { PokemonType(name: $0.type.name) }
        self.imageUrl = response.sprites.other?.officialArtwork?.frontDefault
        self.sprites = PokemonImageSprites(
            frontDefault: response.sprites.frontDefault,
            frontShiny: response.sprites.frontShiny
        )
        self.isFavorited = isFavorited
    }

    // For mock data
    public init(id: Int, name: String, types: [PokemonType], imageUrl: String? = nil, isFavorited: Bool = false) {
        self.id = id
        self.name = name
        self.types = types
        self.imageUrl = imageUrl
        self.sprites = nil
        self.isFavorited = isFavorited
    }
}

public struct PokemonType {
    public let name: String

    public var displayName: String {
        return name.capitalized
    }
}

public struct PokemonImageSprites {
    public let frontDefault: String?
    public let frontShiny: String?
}
