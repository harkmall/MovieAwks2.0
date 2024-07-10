//
//  TMDBController.swift
//
//
//  Created by Mark Hall on 2024-06-26.
//

import Foundation
import Vapor
import Fluent

struct TMDBController {
    
    private let tmbdAuthToken = Environment.get("TMDB_AUTH_TOKEN")
    
    @Sendable
    private func trending(req: Request) async throws -> TrendingResponse {
        
        let configuration = try await imagesConfiguration(req: req)
        
        guard let tmbdAuthToken = tmbdAuthToken else { throw Abort(.badRequest, reason: "TMDB Auth Token not found") }
        guard let trendingType = req.parameters.get("type"),
              let type = TrendingObject.MediaType(rawValue: trendingType) else { throw Abort(.notFound) }
        
        let timeFrame = req.query["time"] ?? "week"
        let page = req.query["page"] ?? 1
        
        var trendingResponse = try await req.client
            .get("https://api.themoviedb.org/3/trending/\(type.rawValue)/\(timeFrame)") {
                try $0.query.encode(["language": "en-US", "page": "\(page)"])
                $0.headers.bearerAuthorization = .init(token: tmbdAuthToken)
            }
            .content
            .decode(TrendingResponse.self)
        
        for index in trendingResponse.results.indices {
            let currentId = trendingResponse.results[index].id
            let averageRating = try await MovieRating.query(on: req.db)
                .filter(\.$movieId == currentId)
                .average(\.$rating)
            trendingResponse.results[index].rating = averageRating
            trendingResponse.results[index].buildImageUrls(with: configuration)
        }
        
        return trendingResponse
    }
    
    @Sendable
    private func imagesConfiguration(req: Request) async throws -> ImagesConfiguration {
        
        if let cachedConfig = try await ImagesConfiguration.getDBConfiguration(req: req) { return cachedConfig }

        guard let tmdbAuthToken = tmbdAuthToken else { throw Abort(.badRequest, reason: "TMDB Auth Token not found") }
        
        let imageConfiguration = try await req.client
            .get("https://api.themoviedb.org/3/configuration") {
                $0.headers.bearerAuthorization = .init(token: tmdbAuthToken)
            }
            .content
            .decode(ConfigurationResponse.self)
            .images
        
        imageConfiguration.expiresAt = Date() + ProjectConfig.ImagesConfiguration.expirationTime
        
        try await imageConfiguration.save(on: req.db)
        
        return imageConfiguration
    }
    
    @Sendable
    private func movieDetail(req: Request) async throws -> MovieDetail {
        guard let tmdbAuthToken = tmbdAuthToken else { throw Abort(.badRequest, reason: "TMDB Auth Token not found") }
        guard let movieId = req.parameters.get("id", as: Int.self) else { throw Abort(.badRequest, reason: "MovieId not present in request") }
        
        let configuration = try await imagesConfiguration(req: req)
        
        var movieDetailResponse = try await req.client
            .get("https://api.themoviedb.org/3/movie/\(movieId)") {
                $0.headers.bearerAuthorization = .init(token: tmdbAuthToken)
            }
            .content
            .decode(MovieDetail.self)
        
        movieDetailResponse.buildImageUrls(with: configuration)
        
        return movieDetailResponse
    }
    
}

// MARK: - RouteCollection
extension TMDBController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("trending",":type", use: trending)
        routes.get("imagesConfiguration", use: imagesConfiguration)
        routes.get("movies", "details", ":id", use: movieDetail)
    }
}
