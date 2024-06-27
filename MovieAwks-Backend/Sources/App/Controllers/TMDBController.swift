//
//  TMDBController.swift
//
//
//  Created by Mark Hall on 2024-06-26.
//

import Foundation
import Vapor

struct TMDBController {
    
    private let tmbdAuthToken = Environment.get("TMDB_AUTH_TOKEN")
    
    @Sendable
    private func trending(req: Request) async throws -> TrendingResponse {
        guard let tmbdAuthToken = tmbdAuthToken else { throw Abort(.badRequest, reason: "TMDB Auth Token not found") }
        guard let trendingType = req.parameters.get("type"),
              let type = TrendingObject.MediaType(rawValue: trendingType) else { throw Abort(.notFound) }
        
        let timeFrame = req.query["time"] ?? "week"
        let page = req.query["page"] ?? 1
        return try await req.client
            .get("https://api.themoviedb.org/3/trending/\(type.rawValue)/\(timeFrame)") { req in
                try req.query.encode(["language": "en-US", "page": "\(page)"])
                req.headers.bearerAuthorization = .init(token: tmbdAuthToken)
            }
            .content
            .decode(TrendingResponse.self)
    }
    
}

// MARK: - RouteCollection
extension TMDBController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("trending",":type", use: trending)
    }
}
