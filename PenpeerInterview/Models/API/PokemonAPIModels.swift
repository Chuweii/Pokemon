//
//  PokemonAPIModels.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

// MARK: - Pokemon List Response
struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String

    var id: Int? {
        // Extract ID from URL: https://pokeapi.co/api/v2/pokemon/1/
        let components = url.split(separator: "/")
        guard let lastComponent = components.dropLast().last else { return nil }
        return Int(lastComponent)
    }
}

// MARK: - Pokemon Detail Response
struct PokemonDetailResponse: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int?
    let types: [PokemonTypeSlot]
    let stats: [PokemonStat]
    let sprites: PokemonSprites
    let abilities: [PokemonAbility]

    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, types, stats, sprites, abilities
        case baseExperience = "base_experience"
    }
}

struct PokemonTypeSlot: Decodable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Decodable {
    let name: String
    let url: String
}

struct PokemonStat: Decodable {
    let baseStat: Int
    let effort: Int
    let stat: StatInfo

    enum CodingKeys: String, CodingKey {
        case effort, stat
        case baseStat = "base_stat"
    }
}

struct StatInfo: Decodable {
    let name: String
    let url: String
}

struct PokemonSprites: Decodable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?
    let other: OtherSprites?

    enum CodingKeys: String, CodingKey {
        case other
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
    }
}

struct OtherSprites: Decodable {
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    let frontDefault: String?
    let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct PokemonAbility: Decodable {
    let isHidden: Bool
    let slot: Int
    let ability: AbilityInfo

    enum CodingKeys: String, CodingKey {
        case slot, ability
        case isHidden = "is_hidden"
    }
}

struct AbilityInfo: Decodable {
    let name: String
    let url: String
}
