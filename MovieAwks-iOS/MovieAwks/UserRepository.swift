//
//  UserRepository.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire
import KeychainSwift

class UserRepository: ObservableObject {

    @Published var accessToken: String?
    @Published var user: User?
    
    private let environment: Networking.Environment
    private let keychain = KeychainSwift()
    private let accessTokenKey = "ACCESS_TOKEN"
    
    init(environment: Networking.Environment) {
        self.environment = environment
        self.accessToken = keychain.get(accessTokenKey)
    }
    
}

// MARK: - User Actions
extension UserRepository {
    func getUser() async throws {
        guard let accessToken = accessToken else { throw APIError.unauthorized }
        
        let userService = UserService.me(bearerToken: accessToken)
        
        let userResponse = try await AF
            .request(environment.baseURL + userService.path,
                     headers: userService.headers)
            .serializingDecodable(UserResponse.self)
            .value
        await MainActor.run {
            self.user = userResponse.user
        }
    }
    
    func logoutUser() {
        self.accessToken = nil
    }
}

// MARK: - Auth Actions
extension UserRepository {
    func authorizeUsingSIWA(identityToken: Data?,
                            firstName: String?,
                            lastName: String?) async throws {

        guard let identityToken = identityToken else { throw APIError.identityTokenMissing }
        guard let identityTokenString = String(data: identityToken, encoding: .utf8) else { throw APIError.unableToDecodeIdentityToken }
        
        let service = AuthService.authWithSIWA(firstName: firstName,
                                               lastName: lastName,
                                               appleIdentityToken: identityTokenString)
        
        let request = AF
            .request(environment.baseURL + service.path,
                     method: service.method,
                     parameters: SIWAAuthRequestBody(firstName: firstName,
                                                     lastName: lastName,
                                                     appleIdentityToken: identityTokenString),
                     encoder: JSONParameterEncoder.default)
            .serializingDecodable(UserResponse.self)
        
        let userResponse = try await request.value
        if let accessToken = userResponse.accessToken {
            keychain.set(accessToken, forKey: accessTokenKey)
            await MainActor.run {
                self.accessToken = accessToken
                self.user = userResponse.user
            }
            
        } else {
            throw UserRepository.Error.accessTokenNotInResponse
        }
    }
}

// MARK: - Errors
extension UserRepository {
    enum Error: LocalizedError {
        case accessTokenNotInResponse
        
        var errorDescription: String? {
            switch self {
            case .accessTokenNotInResponse:
                "No Access Token in Response"
            }
        }
    }
}
