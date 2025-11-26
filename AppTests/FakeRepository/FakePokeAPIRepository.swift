//
//  FakePokeAPIRepository.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/25.
//

import Testing
import Pokemon
import Moya
@testable import PenpeerInterview


class FakePokeAPIRepository: PokeAPIRepositoryProtocol {
    var getPokemonListResult: Result<PokemonListResponse, MoyaError> = .failure(MoyaError.requestMapping(""))
    var getPokemonDetailResult: Result<PokemonDetailResponse, MoyaError> = .failure(MoyaError.requestMapping(""))
    var getTypeListResult: Result<TypeListResponse, MoyaError> = .failure(MoyaError.requestMapping(""))
    var getRegionListResult: Result<RegionListResponse, MoyaError> = .failure(MoyaError.requestMapping(""))
    var getRegionDetailResult: Result<RegionDetailResponse, MoyaError> = .failure(MoyaError.requestMapping(""))
    
    var didCallGetPokemonList: Bool = false
    var didCallGetPokemonDetail: Bool = false
    var didCallGetTypeList: Bool = false
    var didCallGetRegionList: Bool = false
    var didCallGetRegionDetail: Bool = false

    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        didCallGetPokemonList = true
        switch getPokemonListResult {
        case .success(let pokemonList):
            return pokemonList
        case .failure(let error):
            throw error
        }
    }
    
    func getPokemonDetail(id: Int) async throws -> PokemonDetailResponse {
        didCallGetPokemonDetail = true
        switch getPokemonDetailResult {
        case .success(let pokemonDetail):
            return pokemonDetail
        case .failure(let error):
            throw error
        }
    }
    
    func getTypeList(limit: Int, offset: Int) async throws -> TypeListResponse {
        didCallGetTypeList = true
        switch getTypeListResult {
        case .success(let typeList):
            return typeList
        case .failure(let error):
            throw error
        }
    }
    
    func getRegionList() async throws -> RegionListResponse {
        didCallGetRegionList = true
        switch getRegionListResult {
        case .success(let regionList):
            return regionList
        case .failure(let error):
            throw error
        }
    }
    
    func getRegionDetail(id: Int) async throws -> RegionDetailResponse {
        didCallGetRegionDetail = true
        switch getRegionDetailResult {
        case .success(let regionDetail):
            return regionDetail
        case .failure(let error):
            throw error
        }
    }
}
