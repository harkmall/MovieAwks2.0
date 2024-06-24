//
//  User.swift
//
//
//  Created by Mark Hall on 2024-06-20.
//

import Foundation
import Fluent
import Vapor

final class User: Model {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "firstName")
    var firstName: String?
    
    @Field(key: "lastName")
    var lastName: String?
    
    @Field(key: "appleUserIdentifier")
    var appleUserIdentifier: String?
    
    init() { }
    
    init(
        id: UUID? = nil,
        email: String,
        firstName: String? = nil,
        lastName: String? = nil,
        appleUserIdentifier: String
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.appleUserIdentifier = appleUserIdentifier
    }
}

// MARK: - Public representation of a User
extension User {
  struct Public: Content {
    let id: UUID
    let email: String
    let firstName: String?
    let lastName: String?

    init(user: User) throws {
      self.id = try user.requireID()
      self.email = user.email
      self.firstName = user.firstName
      self.lastName = user.lastName
    }
  }

  func asPublic() throws -> Public {
    try .init(user: self)
  }
}

extension User: Authenticatable {}

extension User {
    func createAccessToken(req: Request) throws -> Token {
        let expiryDate = Date() + ProjectConfig.AccessToken.expirationTime
        return try Token(
            userID: requireID(),
            token: [UInt8].random(count: 32).base64,
            expiresAt: expiryDate
        )
    }
    
    static func assertUniqueEmail(_ email:String, req: Request) async throws -> Void {
        do {
            try await findByEmail(email, req: req)
                .flatMap { _ in Void() }
        }
        catch {
            throw UserError.emailTaken
        }
    }
    
    static func findByEmail(_ email: String, req: Request) async throws -> User? {
        try await User.query(on: req.db)
            .filter(\.$email == email)
            .first()
    }
}

extension User {
    static func findByAppleIdentifier(_ identifier: String, req: Request) async throws -> User? {
        try await User.query(on: req.db)
            .filter(\.$appleUserIdentifier == identifier)
            .first()
    }
}
