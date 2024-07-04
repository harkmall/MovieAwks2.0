//
//  ImagesConfigurationMigration.swift
//
//
//  Created by Mark Hall on 2024-07-02.
//

import Fluent

struct ImagesConfigurationMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(ImagesConfiguration.schema)
            .id()
            .field("baseUrl", .string, .required)
            .field("secureBaseUrl", .string, .required)
            .field("backdropSizes", .array(of: .string), .required)
            .field("logoSizes", .array(of: .string), .required)
            .field("posterSizes", .array(of: .string), .required)
            .field("profileSizes", .array(of: .string), .required)
            .field("stillSizes", .array(of: .string), .required)
            .field("createdAt", .datetime, .required)
            .field("expiresAt", .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(ImagesConfiguration.schema).delete()
    }
}


