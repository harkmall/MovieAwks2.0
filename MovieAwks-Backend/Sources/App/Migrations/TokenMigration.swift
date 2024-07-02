//
//  TokenMigration.swift
//
//
//  Created by Mark Hall on 2024-06-20.
//

import Fluent

struct TokenMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Token.schema)
            .field("id", .uuid, .identifier(auto: false))
            .field("userID", .uuid, .references("users", "id"))
            .field("value", .string, .required)
            .unique(on: "value")
            .field("createdAt", .datetime, .required)
            .field("expiresAt", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Token.schema).delete()
    }
}
