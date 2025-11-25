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
    var getFavoritePokemonIdsResult: Result<Set<Int>, MoyaError> = .failure(MoyaError.requestMapping(""))
    var isFavoritedResult: Result<Bool, MoyaError> = .failure(MoyaError.requestMapping(""))
    var addFavoriteResult: Result<Any?, MoyaError> = .failure(MoyaError.requestMapping(""))
    var removeFavoriteResult: Result<Any?, MoyaError> = .failure(MoyaError.requestMapping(""))
    var toggleFavoriteResult: Result<Bool, MoyaError> = .failure(MoyaError.requestMapping(""))
    
    var didCallGetFavoritePokemonIds: Bool = false
    var didCallIsFavorited: Bool = false
    var didCallAddFavorite: Bool = false
    var didCallRemoveFavorite: Bool = false
    var didCallToggleFavorite: Bool = false
    
    func getFavoritePokemonIds() -> Set<Int> {
        didCallGetFavoritePokemonIds = true
        return .init(1...5)
    }
    
    func isFavorited(pokemonId: Int) -> Bool {
        didCallIsFavorited = true
        return true
    }
    
    func addFavorite(pokemonId: Int) {
        didCallAddFavorite = true
    }
    
    func removeFavorite(pokemonId: Int) {
        didCallRemoveFavorite = true
    }
    
    func toggleFavorite(pokemonId: Int) -> Bool {
        didCallToggleFavorite = true
        return true
    }
}
