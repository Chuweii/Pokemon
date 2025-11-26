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

        func request<T: Decodable & Sendable>(_ target: Target) async throws -> T {
            try await withCheckedThrowingContinuation { continuation in
                provider.request(target) { result in
                    switch result {
                    case .success(let response):
                        continuation.resume(with: Result {
                            try JSONDecoder().decode(T.self, from: response.data)
                        })

                    case .failure(let error):
                        continuation.resume(throwing: NetworkError.moyaError(error))
                    }
                }
            }
        }
    }
}
