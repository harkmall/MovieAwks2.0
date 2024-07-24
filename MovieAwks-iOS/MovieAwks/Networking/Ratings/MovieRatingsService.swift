//
//  MovieRatingsService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-05.
//

import Foundation
import Alamofire

protocol MovieRatingsServiceType: Service {
    func getRatings(forMovie id: Int) async throws -> MovieRatingsResponse
    
    func saveMovieRating(with body: MovieRatingRequestBody) async throws
}

struct MovieRatingsService: MovieRatingsServiceType {    
    let networkingManager: NetworkingManager
    
    func getRatings(forMovie id: Int) async throws -> MovieRatingsResponse {
        return try await networkingManager
            .request(endpoint: "/api/movies/ratings/\(id)", decodingType: MovieRatingsResponse.self)
    }
    
    func saveMovieRating(with body: MovieRatingRequestBody) async throws {
        
        _ = try await networkingManager
            .request(endpoint: "/api/movies/ratings",
                     method: .post,
                     parameters: body,
                     decodingType: Empty.self)
    }
}

struct Mock_MovieRatingsService: MovieRatingsServiceType {
    var networkingManager: NetworkingManager
    
    func getRatings(forMovie id: Int) async throws -> MovieRatingsResponse {
        return MovieRatingsResponse(ratings: [MovieRating(id: .init(),
                                                          user: User(id: .init(),
                                                                     email: "email@email.com",
                                                                     firstName: "Mark",
                                                                     lastName: "Hall"),
                                                          createdAt: Date(),
                                                          movieId: 1234,
                                                          rating: 6.9,
                                                          comment: "Some comment"),
                                              MovieRating(id: .init(),
                                                          user: User(id: .init(),
                                                                     email: "email@email.com",
                                                                     firstName: "Mark",
                                                                     lastName: "Hall"),
                                                          createdAt: Date(),
                                                          movieId: 1234,
                                                          rating: 6.9,
                                                          comment: "Some comment 2"),
                                              MovieRating(id: .init(),
                                                          user: User(id: .init(),
                                                                     email: "email@email.com",
                                                                     firstName: "Mark",
                                                                     lastName: "Hall"),
                                                          createdAt: Date(),
                                                          movieId: 1234,
                                                          rating: 6.9,
                                                          comment: "Some comment 3")],
                                    totalRatings: 3,
                                    averageRating: 6.9)
    }
    
    func saveMovieRating(with body: MovieRatingRequestBody) async throws { }
}
