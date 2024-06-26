//
//  APIError.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation

enum APIError: LocalizedError {
    case identityTokenMissing
    case unableToDecodeIdentityToken
    case unableToEncodeJSONData
    case unableToDecodeJSONData
    case unauthorized
    case invalidResponse
    case httpError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .identityTokenMissing:
            return "Missing Identity Token"
        case .unableToDecodeIdentityToken:
            return ""
        case .unableToEncodeJSONData:
            return ""
        case .unableToDecodeJSONData:
            return ""
        case .unauthorized:
            return ""
        case .invalidResponse:
            return ""
        case .httpError(statusCode: let statusCode):
            return "\(statusCode)"
        }
    }
}
