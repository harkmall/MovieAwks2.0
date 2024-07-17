//
//  TMDBService.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation
import Alamofire

enum TrendingType: String {
    case movie
    case tv
}

enum TrendingTimeFrame: String {
    case week
    case day
}

protocol TMDBServiceType: Service {
    func getTrending(type: TrendingType,
                     timeFrame: TrendingTimeFrame,
                     page: Int) async throws -> TrendingResponse
    
    func getMovieDetails(movieId: Int) async throws -> MovieDetail
    
    func searchForMovie(query: String) async throws -> TrendingResponse
}

struct TMDBService: TMDBServiceType {    
    let networkingManager: NetworkingManager
    
    func getTrending(type: TrendingType,
                     timeFrame: TrendingTimeFrame = .week,
                     page: Int) async throws -> TrendingResponse {
        return try await networkingManager
            .request(endpoint: "/api/trending/\(type.rawValue)",
                     parameters: ["time": timeFrame.rawValue, "page": "\(page)"],
                     decodingType: TrendingResponse.self)
    }
    
    func getMovieDetails(movieId: Int) async throws -> MovieDetail {
        return try await networkingManager
            .request(endpoint: "/api/movies/details/\(movieId)",
                     decodingType: MovieDetail.self)
    }
    
    func searchForMovie(query: String) async throws -> TrendingResponse {
        return try await networkingManager
            .request(endpoint: "/api/search/movie",
                     parameters: ["query": query],
                     decodingType: TrendingResponse.self)
    }
}
