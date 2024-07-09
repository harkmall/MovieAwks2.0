//
//  UserService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire

protocol UserServiceType: Service {
    func getUser() async throws -> User
}

struct UserService: UserServiceType {
    let networkingManager: NetworkingManager
        
    func getUser() async throws -> User {
        return try await networkingManager
            .request(endpoint: "/api/users/me", decodingType: UserResponse.self)
            .user
    }
}
