//
//  UserRepository.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire
import KeychainSwift

@MainActor
class UserRepository: ObservableObject {
    @Published var accessToken: String?
    @Published var user: User?
    
    private let userService: UserServiceType
    private let authService: AuthServiceType
    private let keychain = KeychainSwift()
    
    init(userService: UserServiceType = UserService(networkingManager: .current),
         authService: AuthServiceType = AuthService(networkingManager: .current)) {
        self.userService = userService
        self.authService = authService
        self.accessToken = keychain.get(MovieAwksApp.accessTokenKey)
    }
    
}

// MARK: - User Actions
extension UserRepository {
    func getUser() async throws {
        let user = try await userService.getUser()
        self.user = user
    }
    
    func logoutUser() {
        keychain.delete(MovieAwksApp.accessTokenKey)
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
        keychain.set(accessToken, 
                     forKey: MovieAwksApp.accessTokenKey)
        self.user = userResponse.user
        self.accessToken = accessToken
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
