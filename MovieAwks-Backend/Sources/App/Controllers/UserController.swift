//
//  UserController.swift
//
//
//  Created by Mark Hall on 2024-06-20.
//

import Fluent
import Vapor
import JWT

struct UserController {
    @Sendable
    func getMeHandler(req: Request) throws -> UserResponse {
        let user = try req.auth.require(User.self)
        return try .init(user: user)
    }
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("me", use: getMeHandler)
    }
}

