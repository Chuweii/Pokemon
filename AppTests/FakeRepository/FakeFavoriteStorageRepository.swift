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
    
    func getFavoritePokemonIds() -> Set<Int> {
        didCallGetFavoritePokemonIds = true
        return favorites
    }
    
    func isFavorited(pokemonID: Int) -> Bool {
        didCallIsFavorited = true
        return favorites.contains(pokemonID)
    }

    func addFavorite(pokemonId: Int) {
        didCallAddFavorite = true
        favorites.insert(pokemonId)
    }

    func removeFavorite(pokemonId: Int) {
        didCallRemoveFavorite = true
        favorites.remove(pokemonId)
    }

    func toggleFavorite(pokemonId: Int) -> Bool {
        didCallToggleFavorite = true
        if favorites.contains(pokemonId) {
            favorites.remove(pokemonId)
            return false
        } else {
            favorites.insert(pokemonId)
            return true
        }
    }
}
