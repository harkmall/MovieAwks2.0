//
//  UserService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire

protocol UserServiceType: Service {
    func getUser(accessToken: String) async throws -> User
}

struct UserService: UserServiceType {
    var environment: Networking.Environment
    
    init(environment: Networking.Environment = .development) {
        self.environment = environment
    }
    
    func getUser(accessToken: String) async throws -> User {
        return try await AF
            .request(environment.baseURL + "/api/users/me",
                     headers: [.authorization(bearerToken: accessToken)])
            .serializingDecodable(UserResponse.self)
            .value
            .user
    }
    
}
