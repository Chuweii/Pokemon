//
//  FavoriteStorage.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

public protocol FavoriteStorageProtocol {
    func getFavoritePokemonIds() -> Set<Int>
    func isFavorited(pokemonId: Int) -> Bool
    func addFavorite(pokemonId: Int)
    func removeFavorite(pokemonId: Int)
    func toggleFavorite(pokemonId: Int) -> Bool
    func clearAllFavorites()
}

public class FavoriteStorage: FavoriteStorageProtocol {

    private let userDefaults: UserDefaults
    private let favoritesKey = "favoritePokemonIds"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // Get all favorite Pokemon IDs
    public func getFavoritePokemonIds() -> Set<Int> {
        if let array = userDefaults.array(forKey: favoritesKey) as? [Int] {
            let favorites = Set(array)
            print("Loaded favorites from UserDefaults: \(array)")
            return favorites
        }
        print("No favorites found in UserDefaults")
        return Set()
    }

    // Check if a Pokemon is favorited
    public func isFavorited(pokemonId: Int) -> Bool {
        return getFavoritePokemonIds().contains(pokemonId)
    }

    // Add a Pokemon to favorites
    public func addFavorite(pokemonId: Int) {
        var favorites = getFavoritePokemonIds()
        favorites.insert(pokemonId)
        print("Adding Pokemon #\(pokemonId) to favorites")
        saveFavorites(favorites)
    }

    // Remove a Pokemon from favorites
    public func removeFavorite(pokemonId: Int) {
        var favorites = getFavoritePokemonIds()
        favorites.remove(pokemonId)
        print("Removing Pokemon #\(pokemonId) from favorites")
        saveFavorites(favorites)
    }

    // Toggle favorite status
    public func toggleFavorite(pokemonId: Int) -> Bool {
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
    public func clearAllFavorites() {
        userDefaults.removeObject(forKey: favoritesKey)
        userDefaults.synchronize()
        print("Cleared all favorites")
    }
}
