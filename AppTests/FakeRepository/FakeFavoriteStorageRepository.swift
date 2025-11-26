//
//  FakeFavoriteStorageRepository.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/25.
//

import Testing
import Moya
@testable import PenpeerInterview


class FakeFavoriteStorageRepository: FavoriteStorageRepositoryProtocol {
    var didCallGetFavoritePokemonIds: Bool = false
    var didCallIsFavorited: Bool = false
    var didCallAddFavorite: Bool = false
    var didCallRemoveFavorite: Bool = false
    var didCallToggleFavorite: Bool = false
    
    var favorites: Set<Int>
    
    // Initialize with optional predefined favorites
    init(initialFavorites: Set<Int> = []) {
        self.favorites = initialFavorites
    }
    
    func getFavoritePokemonIDs() -> Set<Int> {
        didCallGetFavoritePokemonIds = true
        return favorites
    }
    
    func isFavorited(pokemonID: Int) -> Bool {
        didCallIsFavorited = true
        return favorites.contains(pokemonID)
    }

    func addFavorite(pokemonID: Int) {
        didCallAddFavorite = true
        favorites.insert(pokemonID)
    }

    func removeFavorite(pokemonID: Int) {
        didCallRemoveFavorite = true
        favorites.remove(pokemonID)
    }

    func toggleFavorite(pokemonID: Int) -> Bool {
        didCallToggleFavorite = true
        if favorites.contains(pokemonID) {
            favorites.remove(pokemonID)
            return false
        } else {
            favorites.insert(pokemonID)
            return true
        }
    }
}
