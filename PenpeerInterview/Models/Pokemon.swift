//
//  Pokemon.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let types: [PokemonType]
    let imageUrl: String?
    let sprites: PokemonImageSprites?
    var isFavorited: Bool

    var formattedNumber: String {
        return "#\(id)"
    }

    var capitalizedName: String {
        return name.uppercased()
    }

    // Convert from API Response
    init(from response: PokemonDetailResponse, isFavorited: Bool = false) {
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
    init(id: Int, name: String, types: [PokemonType], imageUrl: String? = nil, isFavorited: Bool = false) {
        self.id = id
        self.name = name
        self.types = types
        self.imageUrl = imageUrl
        self.sprites = nil
        self.isFavorited = isFavorited
    }
}

struct PokemonType {
    let name: String

    var displayName: String {
        return name.capitalized
    }
}

struct PokemonImageSprites {
    let frontDefault: String?
    let frontShiny: String?
}
