//
//  PokeAPIRepository.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation
import Moya

public protocol PokeAPIRepositoryProtocol {
    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse
    func getPokemonDetail(id: Int) async throws -> PokemonDetailResponse
    func getTypeList(limit: Int, offset: Int) async throws -> TypeListResponse
    func getRegionList() async throws -> RegionListResponse
    func getRegionDetail(id: Int) async throws -> RegionDetailResponse
}

public class PokeAPIRepository: PokeAPIRepositoryProtocol {

    private let provider = MoyaProvider<PokeAPIManager>()

    public init() {}

    public func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        return try await provider.async.request(.getPokemonList(limit: limit, offset: offset))
    }

    public func getPokemonDetail(id: Int) async throws -> PokemonDetailResponse {
        return try await provider.async.request(.getPokemonDetail(id: id))
    }

    public func getTypeList(limit: Int, offset: Int) async throws -> TypeListResponse {
        return try await provider.async.request(.getTypeList(limit: limit, offset: offset))
    }

    public func getRegionList() async throws -> RegionListResponse {
        return try await provider.async.request(.getRegionList)
    }

    public func getRegionDetail(id: Int) async throws -> RegionDetailResponse {
        return try await provider.async.request(.getRegionDetail(id: id))
    }
}

