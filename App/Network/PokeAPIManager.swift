//
//  PokeAPIManager.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation
import Moya
import Alamofire

enum PokeAPIManager {
    case getPokemonList(limit: Int, offset: Int)
    case getPokemonDetail(id: Int)
    case getTypeList(limit: Int, offset: Int)
    case getRegionList
    case getRegionDetail(id: Int)
}

extension PokeAPIManager: TargetType {
    enum APIURL {
        static let baseURL = "https://pokeapi.co/api/v2"
    }

    var baseURL: URL {
        URL(string: APIURL.baseURL)!
    }

    var path: String {
        switch self {
        case .getPokemonList:
            return "/pokemon"
        case .getPokemonDetail(let id):
            return "/pokemon/\(id)"
        case .getTypeList:
            return "/type"
        case .getRegionList:
            return "/region"
        case .getRegionDetail(let id):
            return "/region/\(id)"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        switch self {
        case .getPokemonList(let limit, let offset):
            return .requestParameters(
                parameters: ["limit": limit, "offset": offset],
                encoding: URLEncoding.default
            )
        case .getTypeList(let limit, let offset):
            return .requestParameters(
                parameters: ["limit": limit, "offset": offset],
                encoding: URLEncoding.default
            )
        case .getPokemonDetail, .getRegionList, .getRegionDetail:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        ["Content-type": "application/json"]
    }
}
