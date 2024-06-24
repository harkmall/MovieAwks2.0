//
//  UserMigration.swift
//
//
//  Created by Mark Hall on 2024-06-20.
//

import Fluent

struct UserMigration: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("email", .string, .required)
            .field("firstName", .string)
            .field("lastName", .string)
            .field("appleUserIdentifier", .string, .required)
            .create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
