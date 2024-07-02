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
    
    private let userService: UserServiceType
    private let authService: AuthServiceType
    private let keychain = KeychainSwift()
    private let accessTokenKey = "ACCESS_TOKEN"
    
    init(userService: UserServiceType = UserService(environment: .current),
         authService: AuthServiceType = AuthService(environment: .current)) {
        self.userService = userService
        self.authService = authService
        self.accessToken = keychain.get(accessTokenKey)
    }
    
}

// MARK: - User Actions
extension UserRepository {
    func getUser() async throws {
        guard let accessToken = accessToken else { throw APIError.unauthorized }
        let user = try await userService.getUser(accessToken: accessToken)
        await MainActor.run {
            self.user = user
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
        
        let userResponse = try await authService.authWithSIWA(firstName: firstName,
                                                              lastName: lastName,
                                                              appleIdentityToken: identityToken)
        
        guard let accessToken = userResponse.accessToken else { throw UserRepository.Error.accessTokenNotInResponse }
        keychain.set(accessToken, forKey: accessTokenKey)
        await MainActor.run {
            self.user = userResponse.user
            self.accessToken = accessToken
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
