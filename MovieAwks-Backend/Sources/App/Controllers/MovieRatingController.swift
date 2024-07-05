//
//  MovieRatingController.swift
//
//
//  Created by Mark Hall on 2024-07-04.
//

import Fluent
import Vapor

struct MovieRatingController {
    @Sendable
    private func postNewMovieRating(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let rating = try req.content.decode(MovieRating.Public.self)
        try await MovieRating(user: user, 
                              publicObject: rating)
            .save(on: req.db)
        
        return .ok
        
    }
    
    @Sendable
    private func getMovieRatings(req: Request) async throws -> MovieRatingsResponse {
        guard let movieId = req.parameters.get("id", as: Int.self) else { throw Abort(.badRequest, reason: "MovieId not present in request") }
        
        let ratings = try await MovieRating.query(on: req.db)
            .filter(\.$movieId == movieId)
            .sort(\.$createdAt)
            .with(\.$user)
            .all()
        
        let totalRatings = ratings.count
        var averageRating: Float = 0
        if totalRatings > 0 {
            averageRating = ratings.map { $0.rating }.reduce(0, +) / Float(totalRatings)
        }
        
        return MovieRatingsResponse(ratings: ratings, 
                                    totalRatings: totalRatings,
                                    averageRating: averageRating)
    }
}

// MARK: - RouteCollection
extension MovieRatingController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let movies = routes.grouped("movies", "ratings")
        movies.post(use: postNewMovieRating)
        
        movies.group(":id") { movies in
            movies.get(use: getMovieRatings)
        }
    }
}
