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
}

struct MovieRatingsService: MovieRatingsServiceType {
    let environment: Networking.Environment
    let responseJSONDecoder: JSONDecoder

    init(environment: Networking.Environment = .current) {
        self.environment = environment
        
        self.responseJSONDecoder = JSONDecoder()
        self.responseJSONDecoder.dateDecodingStrategy = .secondsSince1970
    }
    
    func getRatings(accessToken: String,
                    forMovie id: Int) async throws -> MovieRatingsResponse {
        return try await AF
            .request(environment.baseURL + "/api/movies/ratings/\(id)",
                     headers: [.authorization(bearerToken: accessToken)])
            .serializingDecodable(MovieRatingsResponse.self, 
                                  decoder: self.responseJSONDecoder)
            .value
    }
}
