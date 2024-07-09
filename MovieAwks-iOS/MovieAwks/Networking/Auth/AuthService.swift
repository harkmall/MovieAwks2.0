//
//  AuthService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire

protocol AuthServiceType: Service {
    func authWithSIWA(firstName: String?, lastName: String?, appleIdentityToken: Data?) async throws -> UserResponse
}

struct AuthService: AuthServiceType {
    let networkingManager: NetworkingManager

    func authWithSIWA(firstName: String?, lastName: String?, appleIdentityToken: Data?) async throws -> UserResponse {
        guard let appleIdentityToken = appleIdentityToken else { throw APIError.identityTokenMissing }
        guard let identityTokenString = String(data: appleIdentityToken, encoding: .utf8) else { throw APIError.unableToDecodeIdentityToken }
        
        return try await networkingManager
            .request(needsAuth: false,
                     endpoint: "/api/auth/siwa",
                     method: .post,
                     parameters: SIWAAuthRequestBody(firstName: firstName,
                                                     lastName: lastName,
                                                     appleIdentityToken: identityTokenString),
                     decodingType: UserResponse.self)
    }
}
