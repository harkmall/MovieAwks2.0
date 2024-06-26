//
//  SIWAController.swift
//
//
//  Created by Mark Hall on 2024-06-20.
//

import Fluent
import Vapor
import JWT

struct SIWAController {
    
    struct SIWARequestBody: Content {
        let firstName: String?
        let lastName: String?
        let appleIdentityToken: String
    }
    
    @Sendable
    func authHandler(req: Request) async throws -> UserResponse {
        let userBody = try req.content.decode(SIWARequestBody.self)
        
        let appleIdentityToken = try await req.jwt.apple.verify(userBody.appleIdentityToken, 
                                                                applicationIdentifier: ProjectConfig.SIWA.applicationIdentifier)
        let user = try await User.findByAppleIdentifier(appleIdentityToken.subject.value, 
                                                        req: req)
        if user == nil {
            return try await SIWAController.signUp(appleIdentityToken: appleIdentityToken,
                                                   firstName: userBody.firstName,
                                                   lastName: userBody.lastName,
                                                   req: req)
        } else {
            return try await SIWAController.signIn(user: user,
                                                   req: req)
        }
    }
    
    
    static func signUp(appleIdentityToken: AppleIdentityToken,
                       firstName: String? = nil,
                       lastName: String? = nil,
                       req: Request) async throws -> UserResponse {
        guard let email = appleIdentityToken.email else {
            throw UserError.siwaEmailMissing
        }
        
        try await User.assertUniqueEmail(email, req: req)
        
        let user = User(email: email,
                        firstName: firstName,
                        lastName: lastName,
                        appleUserIdentifier: appleIdentityToken.subject.value)
        try await user.save(on: req.db)
        
        guard let accessToken = try? user.createAccessToken(req: req) else {
            throw Abort(.internalServerError)
        }
        try await accessToken.save(on: req.db)
        
        return try .init(accessToken: accessToken, user: user)
    }
    
    static func signIn(user: User?,
                       req: Request) async throws -> UserResponse {
        guard let user = user ,
              let accessToken = try? user.createAccessToken(req: req) else {
            throw Abort(.internalServerError)
        }
        try await accessToken.save(on: req.db)
        
        return try .init(accessToken: accessToken, user: user)
    }
    
}

// MARK: - RouteCollection
extension SIWAController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    routes.post(use: authHandler)
  }
}
