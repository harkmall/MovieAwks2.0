//
//  AuthService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire

enum AuthService {
    case authWithSIWA(firstName: String?, lastName: String?, appleIdentityToken: String)
}

extension AuthService: Service {
    var path: String {
        switch self {
        case .authWithSIWA:
            return "/api/auth/siwa"
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .authWithSIWA(let firstName, let lastName, let appleIdentityToken):
            return SIWAAuthRequestBody(firstName: firstName,
                                       lastName: lastName,
                                       appleIdentityToken: appleIdentityToken)
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .authWithSIWA:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .authWithSIWA:
            return nil
        }
    }
}
