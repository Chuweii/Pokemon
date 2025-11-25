//
//  MoyaConcurrency.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//


import Foundation
import Moya

extension MoyaProvider {
    var async: MoyaConcurrency {
        MoyaConcurrency(provider: self)
    }

    class MoyaConcurrency {
        private let provider: MoyaProvider

        init(provider: MoyaProvider) {
            self.provider = provider
        }

        func request<T: Decodable>(_ target: Target) async throws -> T {
            try await withCheckedThrowingContinuation { continuation in
                provider.request(target) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: response.data)
                            continuation.resume(returning: decodedResponse)
                        } 
                        catch {
                            let customError = NetworkError.customError(.decodingError)
                            continuation.resume(throwing: customError)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: NetworkError.moyaError(error))
                    }
                }
            }
        }
    }
}