//
//  PokemonAPIModels.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

// MARK: - Pokemon List Response

public struct PokemonListResponse: Decodable, Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [PokemonListItem]

    public init(count: Int, next: String?, previous: String?, results: [PokemonListItem]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public struct PokemonListItem: Decodable, Sendable {
    public let name: String
    public let url: String

    public var id: Int? {
        // Extract ID from URL: https://pokeapi.co/api/v2/pokemon/1/
        // Remove trailing slash if exists
        let cleanURL = url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let components = cleanURL.split(separator: "/")
        guard let lastComponent = components.last else { return nil }
        return Int(lastComponent)
    }
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

// MARK: - Pokemon Detail Response

public struct PokemonDetailResponse: Decodable, Sendable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int?
    let types: [PokemonTypeSlot]
    let stats: [PokemonStat]
    let sprites: PokemonSprites
    let abilities: [PokemonAbility]
    
    public init(id: Int, name: String, height: Int, weight: Int, baseExperience: Int?, types: [PokemonTypeSlot], stats: [PokemonStat], sprites: PokemonSprites, abilities: [PokemonAbility]) {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.baseExperience = baseExperience
        self.types = types
        self.stats = stats
        self.sprites = sprites
        self.abilities = abilities
    }

    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, types, stats, sprites, abilities
        case baseExperience = "base_experience"
    }
}

public struct PokemonTypeSlot: Decodable, Sendable {
    let slot: Int
    let type: TypeInfo
    
    public init(slot: Int, type: TypeInfo) {
        self.slot = slot
        self.type = type
    }
}

public struct TypeInfo: Decodable, Sendable {
    let name: String
    let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

public struct PokemonStat: Decodable, Sendable {
    let baseStat: Int
    let effort: Int
    let stat: StatInfo
    
    public init(baseStat: Int, effort: Int, stat: StatInfo) {
        self.baseStat = baseStat
        self.effort = effort
        self.stat = stat
    }

    enum CodingKeys: String, CodingKey {
        case effort, stat
        case baseStat = "base_stat"
    }
}

public struct StatInfo: Decodable, Sendable {
    let name: String
    let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

public struct PokemonSprites: Decodable, Sendable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?
    let other: OtherSprites?
    
    public init(frontDefault: String?, frontShiny: String?, backDefault: String?, backShiny: String?, other: OtherSprites?) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
        self.backDefault = backDefault
        self.backShiny = backShiny
        self.other = other
    }

    enum CodingKeys: String, CodingKey {
        case other
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
    }
}

public struct OtherSprites: Decodable, Sendable {
    let officialArtwork: OfficialArtwork?
    
    public init(officialArtwork: OfficialArtwork?) {
        self.officialArtwork = officialArtwork
    }

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

public struct OfficialArtwork: Decodable, Sendable {
    let frontDefault: String?
    let frontShiny: String?
    
    public init(frontDefault: String?, frontShiny: String?) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
    }

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

public struct PokemonAbility: Decodable, Sendable {
    let isHidden: Bool
    let slot: Int
    let ability: AbilityInfo
    
    public init(isHidden: Bool, slot: Int, ability: AbilityInfo) {
        self.isHidden = isHidden
        self.slot = slot
        self.ability = ability
    }

    enum CodingKeys: String, CodingKey {
        case slot, ability
        case isHidden = "is_hidden"
    }
}

public struct AbilityInfo: Decodable, Sendable {
    let name: String
    let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
