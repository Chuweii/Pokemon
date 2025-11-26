//
//  FavoriteStorage.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

protocol FavoriteStorageProtocol {
    func getFavoritePokemonIDs() -> Set<Int>
    func isFavorited(pokemonID: Int) -> Bool
    func addFavorite(pokemonID: Int)
    func removeFavorite(pokemonID: Int)
    func toggleFavorite(pokemonID: Int) -> Bool
    func clearAllFavorites()
}

class FavoriteStorage: FavoriteStorageProtocol {

    private let userDefaults: UserDefaults
    private let favoritesKey = "favoritePokemonIds"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // Get all favorite Pokemon IDs
    func getFavoritePokemonIDs() -> Set<Int> {
        if let array = userDefaults.array(forKey: favoritesKey) as? [Int] {
            let favorites = Set(array)
            print("Loaded favorites from UserDefaults: \(array)")
            return favorites
        }
        print("No favorites found in UserDefaults")
        return Set()
    }

    // Check if a Pokemon is favorited
    func isFavorited(pokemonID: Int) -> Bool {
        return getFavoritePokemonIDs().contains(pokemonID)
    }

    // Add a Pokemon to favorites
    func addFavorite(pokemonID: Int) {
        var favorites = getFavoritePokemonIDs()
        favorites.insert(pokemonID)
        print("Adding Pokemon #\(pokemonID) to favorites")
        saveFavorites(favorites)
    }

    // Remove a Pokemon from favorites
    func removeFavorite(pokemonID: Int) {
        var favorites = getFavoritePokemonIDs()
        favorites.remove(pokemonID)
        print("Removing Pokemon #\(pokemonID) from favorites")
        saveFavorites(favorites)
    }

    // Toggle favorite status
    func toggleFavorite(pokemonID: Int) -> Bool {
        if isFavorited(pokemonID: pokemonID) {
            removeFavorite(pokemonID: pokemonID)
            return false
        } else {
            addFavorite(pokemonID: pokemonID)
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
