//
//  Networking.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation
import Alamofire

struct Networking {
    static let baseURL = "https://cba3-66-203-169-98.ngrok-free.app"
    static var accessToken: String?
    
    
    static func authorizeUsingSIWA(identityToken: Data?, 
                                   email: String?,
                                   firstName: String?,
                                   lastName: String?) async throws -> UserResponse {
        
        guard let identityToken = identityToken else { throw APIError.identityTokenMissing }
        guard let identityTokenString = String(data: identityToken, encoding: .utf8) else { throw APIError.unableToDecodeIdentityToken }
        
        let request = AF
            .request(baseURL + "/api/auth/siwa",
                     method: .post,
                     parameters: SIWAAuthRequestBody(firstName: firstName,
                                                     lastName: lastName,
                                                     appleIdentityToken: identityTokenString),
                     encoder: JSONParameterEncoder.default)
            .serializingDecodable(UserResponse.self)
        
        let userResponse = try await request.value
        Networking.accessToken = userResponse.accessToken
        return userResponse
        
    }
    
    static func getUser() async throws -> UserResponse {
        guard let accessToken = Networking.accessToken else { throw APIError.unauthorized }
        
        let request = AF
            .request(baseURL + "/api/users/me",
                     headers: .init(arrayLiteral: .authorization(bearerToken: accessToken)))
            .serializingDecodable(UserResponse.self)
        
        return try await request.value
    }
    
}
