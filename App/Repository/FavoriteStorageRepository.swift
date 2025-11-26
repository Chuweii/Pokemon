//
//  FavoriteRepository.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

protocol FavoriteStorageRepositoryProtocol {
    func getFavoritePokemonIDs() -> Set<Int>
    func isFavorited(pokemonID: Int) -> Bool
    func addFavorite(pokemonID: Int)
    func removeFavorite(pokemonID: Int)
    func toggleFavorite(pokemonID: Int) -> Bool
}

class FavoriteStorageRepository: FavoriteStorageRepositoryProtocol {

    static let shared = FavoriteStorageRepository()

    private let storage: FavoriteStorageProtocol

    init(storage: FavoriteStorageProtocol = FavoriteStorage()) {
        self.storage = storage
    }

    func getFavoritePokemonIDs() -> Set<Int> {
        return storage.getFavoritePokemonIDs()
    }

    func isFavorited(pokemonID: Int) -> Bool {
        return storage.isFavorited(pokemonID: pokemonID)
    }

    func addFavorite(pokemonID: Int) {
        storage.addFavorite(pokemonID: pokemonID)
    }

    func removeFavorite(pokemonID: Int) {
        storage.removeFavorite(pokemonID: pokemonID)
    }

    func toggleFavorite(pokemonID: Int) -> Bool {
        return storage.toggleFavorite(pokemonID: pokemonID)
    }
}
