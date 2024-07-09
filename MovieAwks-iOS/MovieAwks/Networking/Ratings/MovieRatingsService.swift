//
//  MovieRatingsService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-05.
//

import Foundation
import Alamofire

protocol MovieRatingsServiceType: Service {
    func getRatings(accessToken: String,
                    forMovie id: Int) async throws -> MovieRatingsResponse
    
    func saveMovieRating(accessToken: String,
                         with body: MovieRatingRequestBody) async throws
}

struct MovieRatingsService: MovieRatingsServiceType {    
    let networkingManager: NetworkingManager
    
    func getRatings(accessToken: String,
                    forMovie id: Int) async throws -> MovieRatingsResponse {
        return try await networkingManager
            .request(endpoint: "/api/movies/ratings/\(id)", decodingType: MovieRatingsResponse.self)
    }
    
    func saveMovieRating(accessToken: String,
                         with body: MovieRatingRequestBody) async throws {
        
        _ = try await networkingManager
            .request(endpoint: "/api/movies/ratings",
                     method: .post,
                     parameters: body,
                     decodingType: Empty.self)
    }
}
