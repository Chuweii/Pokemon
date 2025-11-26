//
//  PokemonDetailViewModel.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var pokemon: Pokemon

    // MARK: - Repositories
    let favoriteRepository: FavoriteStorageRepositoryProtocol

    // MARK: - Init
    init(
        pokemon: Pokemon,
        favoriteRepository: FavoriteStorageRepositoryProtocol = FavoriteStorageRepository.shared
    ) {
        self.pokemon = pokemon
        self.favoriteRepository = favoriteRepository
    }

    @MainActor
    func refreshFavoriteStatus() {
        let isFavorited = favoriteRepository.isFavorited(pokemonID: pokemon.id)
        pokemon.isFavorited = isFavorited
    }

    // MARK: - Computed Properties
    var formattedID: String {
        return String(format: "#%03d", pokemon.id)
    }

    var capitalizedName: String {
        return pokemon.name.capitalized
    }

    var formattedWeight: String {
        guard let weight = pokemon.weight else { return "0.0 KG" }
        let weightInKg = Double(weight) / 10.0
        return String(format: "%.1f KG", weightInKg)
    }

    var formattedHeight: String {
        guard let height = pokemon.height else { return "0.0 M" }
        let heightInMeters = Double(height) / 10.0
        return String(format: "%.1f M", heightInMeters)
    }

    var statsList: [(name: String, value: Int, maxValue: Int)] {
        guard let stats = pokemon.stats else { return [] }

        // Filter to only show HP, ATK, DEF, SPD
        let filteredStats = stats.compactMap { stat -> (name: String, value: Int, maxValue: Int)? in
            let displayName: String
            switch stat.stat.name {
            case "hp":
                displayName = "HP"
            case "attack":
                displayName = "ATK"
            case "defense":
                displayName = "DEF"
            case "speed":
                displayName = "SPD"
            default:
                return nil // Skip other stats
            }

            return (name: displayName, value: stat.baseStat, maxValue: 255)
        }

        // Sort to ensure consistent order: HP, ATK, DEF, SPD
        let order = ["HP", "ATK", "DEF", "SPD"]
        return filteredStats.sorted { order.firstIndex(of: $0.name) ?? 0 < order.firstIndex(of: $1.name) ?? 0 }
    }

    // MARK: - Actions
    func didClickFavoriteButton() {
        toggleFavorite()
    }
    
    private func toggleFavorite() {
        let newState = favoriteRepository.toggleFavorite(pokemonID: pokemon.id)
        pokemon.isFavorited = newState
    }
}
