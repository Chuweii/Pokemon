//
//  HomeViewModel.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

class HomeViewModel {
    let pokeAPIRepository: PokeAPIRepositoryProtocol
    let favoriteRepository: FavoriteRepositoryProtocol

    init(
        pokeAPIRepository: PokeAPIRepositoryProtocol = PokeAPIRepository(),
        favoriteRepository: FavoriteRepositoryProtocol = FavoriteRepository()
    ) {
        self.pokeAPIRepository = pokeAPIRepository
        self.favoriteRepository = favoriteRepository
    }

    func getFeaturedPokemons() async throws -> [Pokemon] {
        // Get first 9 Pokemon for featured section
        let listResponse = try await pokeAPIRepository.getPokemonList(limit: 9, offset: 0)

        // Fetch details for each Pokemon
        var pokemons: [Pokemon] = []

        for item in listResponse.results {
            guard let id = item.id else { continue }

            do {
                let detail = try await pokeAPIRepository.getPokemonDetail(id: id)
                // Check if this Pokemon is favorited
                let isFavorited = favoriteRepository.isFavorited(pokemonId: id)
                let pokemon = Pokemon(from: detail, isFavorited: isFavorited)
                pokemons.append(pokemon)
            } catch {
                print("Failed to fetch pokemon \(id): \(error)")
            }
        }

        return pokemons
    }

    func getTypes() async throws -> [String] {
        // Get all types
        let typeResponse = try await pokeAPIRepository.getTypeList(limit: 100, offset: 0)
        return typeResponse.results.map { $0.name }
    }

    func getRegions() async throws -> [Region] {
        // Get first 6 regions
        let regionListResponse = try await pokeAPIRepository.getRegionList()
        let firstSixRegions = Array(regionListResponse.results.prefix(6))

        // Fetch details for each region
        var regions: [Region] = []

        for item in firstSixRegions {
            guard let id = item.id else { continue }

            do {
                let detail = try await pokeAPIRepository.getRegionDetail(id: id)
                let region = Region(from: detail)
                regions.append(region)
            } catch {
                print("Failed to fetch region \(id): \(error)")
            }
        }

        return regions
    }
}
