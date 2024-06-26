//
//  UserService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire

enum UserService {
    case me(bearerToken: String)
}

extension UserService: Service {
    var path: String {
        switch self {
        case .me:
            return "/api/users/me"
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .me:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .me:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .me(let bearerToken):
            return .init(arrayLiteral: .authorization(bearerToken: bearerToken))
        }
    }
    
}
