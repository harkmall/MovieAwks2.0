//
//  APIError.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation

enum APIError: Error {
  case identityTokenMissing
  case unableToDecodeIdentityToken
  case unableToEncodeJSONData
  case unableToDecodeJSONData
  case unauthorized
  case invalidResponse
  case httpError(statusCode: Int)
}
