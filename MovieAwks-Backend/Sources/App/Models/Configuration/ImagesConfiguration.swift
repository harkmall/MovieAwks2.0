//
//  ImagesConfiguration.swift
//
//
//  Created by Mark Hall on 2024-07-02.
//

import Foundation
import Vapor
import Fluent

final class ImagesConfiguration: Model, Content {
    static let schema = "imagesConfiguration"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "baseUrl")
    var baseUrl: String?
    
    @Field(key: "secureBaseUrl")
    var secureBaseUrl: String?
    
    @Field(key: "backdropSizes")
    var backdropSizes: [String]?
    
    @Field(key: "logoSizes")
    var logoSizes: [String]?
    
    @Field(key: "posterSizes")
    var posterSizes: [String]?
    
    @Field(key: "profileSizes")
    var profileSizes: [String]?
    
    @Field(key: "stillSizes")
    var stillSizes: [String]?
    
    @Field(key: "expiresAt")
    var expiresAt: Date?

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
        
}

extension ImagesConfiguration {
    static func getDBConfiguration(req: Request) async throws -> ImagesConfiguration? {
        let imagesConfig = try await ImagesConfiguration.query(on: req.db)
            .first()
        guard let expiryDate = imagesConfig?.expiresAt else { return nil }
        
        return expiryDate > Date() ? imagesConfig : nil
    }
}
