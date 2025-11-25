//
//  FavoriteRepository.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

protocol FavoriteStorageRepositoryProtocol {
    func getFavoritePokemonIds() -> Set<Int>
    func isFavorited(pokemonId: Int) -> Bool
    func addFavorite(pokemonId: Int)
    func removeFavorite(pokemonId: Int)
    func toggleFavorite(pokemonId: Int) -> Bool
}

class FavoriteStorageRepository: FavoriteStorageRepositoryProtocol {

    static let shared = FavoriteStorageRepository()

    private let storage: FavoriteStorageProtocol

    init(storage: FavoriteStorageProtocol = FavoriteStorage()) {
        self.storage = storage
    }

    func getFavoritePokemonIds() -> Set<Int> {
        return storage.getFavoritePokemonIds()
    }

    func isFavorited(pokemonId: Int) -> Bool {
        return storage.isFavorited(pokemonId: pokemonId)
    }

    func addFavorite(pokemonId: Int) {
        storage.addFavorite(pokemonId: pokemonId)
    }

    func removeFavorite(pokemonId: Int) {
        storage.removeFavorite(pokemonId: pokemonId)
    }

    func toggleFavorite(pokemonId: Int) -> Bool {
        return storage.toggleFavorite(pokemonId: pokemonId)
    }
}
