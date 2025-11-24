//
//  CustomResponseType.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//


import Foundation
import Moya

enum CustomResponseType {
    case objectMappingError
    case decodingError
}

extension CustomResponseType {
    var response: Response {
        switch self {
        default:
            Response(statusCode: 499, data: Data())
        }
    }
}