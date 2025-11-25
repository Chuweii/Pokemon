//
//  FavoriteStorage.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

protocol FavoriteStorageProtocol {
    func getFavoritePokemonIds() -> Set<Int>
    func isFavorited(pokemonId: Int) -> Bool
    func addFavorite(pokemonId: Int)
    func removeFavorite(pokemonId: Int)
    func toggleFavorite(pokemonId: Int) -> Bool
    func clearAllFavorites()
}

class FavoriteStorage: FavoriteStorageProtocol {

    private let userDefaults: UserDefaults
    private let favoritesKey = "favoritePokemonIds"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // Get all favorite Pokemon IDs
    func getFavoritePokemonIds() -> Set<Int> {
        if let array = userDefaults.array(forKey: favoritesKey) as? [Int] {
            let favorites = Set(array)
            print("Loaded favorites from UserDefaults: \(array)")
            return favorites
        }
        print("No favorites found in UserDefaults")
        return Set()
    }

    // Check if a Pokemon is favorited
    func isFavorited(pokemonId: Int) -> Bool {
        return getFavoritePokemonIds().contains(pokemonId)
    }

    // Add a Pokemon to favorites
    func addFavorite(pokemonId: Int) {
        var favorites = getFavoritePokemonIds()
        favorites.insert(pokemonId)
        print("Adding Pokemon #\(pokemonId) to favorites")
        saveFavorites(favorites)
    }

    // Remove a Pokemon from favorites
    func removeFavorite(pokemonId: Int) {
        var favorites = getFavoritePokemonIds()
        favorites.remove(pokemonId)
        print("Removing Pokemon #\(pokemonId) from favorites")
        saveFavorites(favorites)
    }

    // Toggle favorite status
    func toggleFavorite(pokemonId: Int) -> Bool {
        if isFavorited(pokemonId: pokemonId) {
            removeFavorite(pokemonId: pokemonId)
            return false
        } else {
            addFavorite(pokemonId: pokemonId)
            return true
        }
    }

    // Save favorites to UserDefaults
    private func saveFavorites(_ favorites: Set<Int>) {
        let array = Array(favorites).sorted() // Sort for consistency
        userDefaults.set(array, forKey: favoritesKey)
        userDefaults.synchronize() // Force immediate save
        print("Saved favorites to UserDefaults: \(array)")
    }

    // Clear all favorites (for testing)
    func clearAllFavorites() {
        userDefaults.removeObject(forKey: favoritesKey)
        userDefaults.synchronize()
        print("Cleared all favorites")
    }
}
