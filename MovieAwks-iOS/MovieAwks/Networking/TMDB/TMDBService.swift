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
    func getTrending(accessToken: String, 
                     type: TrendingType,
                     timeFrame: TrendingTimeFrame,
                     page: Int) async throws -> TrendingResponse
    
    func getMovieDetails(accessToken: String,
                         movieId: Int) async throws -> MovieDetail
}

struct TMDBService: TMDBServiceType {
    let environment: Networking.Environment
    
    let responseJSONDecoder: JSONDecoder
    
    init(environment: Networking.Environment) {
        self.environment = environment
        
        self.responseJSONDecoder = JSONDecoder()
        self.responseJSONDecoder.dateDecodingStrategy = .secondsSince1970
    }
    
    func getTrending(accessToken: String,
                     type: TrendingType,
                     timeFrame: TrendingTimeFrame = .week,
                     page: Int) async throws -> TrendingResponse {
        return try await AF
            .request(environment.baseURL + "/api/trending/\(type.rawValue)",
                     parameters: ["time": timeFrame.rawValue, "page": "\(page)"],
                     headers: [.authorization(bearerToken: accessToken)])
            .serializingDecodable(TrendingResponse.self, 
                                  decoder: self.responseJSONDecoder)
            .value
    }
    
    func getMovieDetails(accessToken: String,
                         movieId: Int) async throws -> MovieDetail {
        return try await AF
            .request(environment.baseURL + "/api/movies/details/\(movieId)",
                     headers: [.authorization(bearerToken: accessToken)])
            .serializingDecodable(MovieDetail.self,
                                  decoder: self.responseJSONDecoder)
            .value
    }
}
