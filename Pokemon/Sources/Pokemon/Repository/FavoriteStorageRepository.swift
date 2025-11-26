//
//  FavoriteRepository.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation

public protocol FavoriteStorageRepositoryProtocol {
    func getFavoritePokemonIds() -> Set<Int>
    func isFavorited(pokemonId: Int) -> Bool
    func addFavorite(pokemonId: Int)
    func removeFavorite(pokemonId: Int)
    func toggleFavorite(pokemonId: Int) -> Bool
}

public class FavoriteStorageRepository: FavoriteStorageRepositoryProtocol {

    nonisolated(unsafe) public static let shared = FavoriteStorageRepository()

    private let storage: FavoriteStorageProtocol

    public init(storage: FavoriteStorageProtocol = FavoriteStorage()) {
        self.storage = storage
    }

    public func getFavoritePokemonIds() -> Set<Int> {
        return storage.getFavoritePokemonIds()
    }

    public func isFavorited(pokemonId: Int) -> Bool {
        return storage.isFavorited(pokemonId: pokemonId)
    }

    public func addFavorite(pokemonId: Int) {
        storage.addFavorite(pokemonId: pokemonId)
    }

    public func removeFavorite(pokemonId: Int) {
        storage.removeFavorite(pokemonId: pokemonId)
    }

    public func toggleFavorite(pokemonId: Int) -> Bool {
        return storage.toggleFavorite(pokemonId: pokemonId)
    }
}
