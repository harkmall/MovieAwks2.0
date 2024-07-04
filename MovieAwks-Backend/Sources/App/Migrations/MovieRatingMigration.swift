//
//  MovieRatingMigration.swift
//
//
//  Created by Mark Hall on 2024-07-04.
//

import Fluent

struct MovieRatingMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(MovieRating.schema)
            .id()
            .field("userID", .uuid, .references("users", "id"))
            .field("movieId", .int, .required)
            .field("createdAt", .datetime, .required)
            .field("rating", .float, .required)
            .field("comment", .string)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(MovieRating.schema).delete()
    }
}
