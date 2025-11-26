//
//  NetworkError.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//


import Foundation
import Moya

enum NetworkError: Error {
    case moyaError(MoyaError)
    case customError(CustomResponseType)
}
