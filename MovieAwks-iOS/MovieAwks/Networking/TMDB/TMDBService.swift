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

struct Mock_TMBDService: TMDBServiceType {
    var networkingManager: NetworkingManager
    
    func getTrending(type: TrendingType,
                     timeFrame: TrendingTimeFrame,
                     page: Int) async throws -> TrendingResponse {
        
        TrendingResponse(page: 1, results: [TrendingObject(adult: true,
                                                           backdropPath: "https://image.tmdb.org/t/p/w1280/wNAhuOZ3Zf84jCIlrcI6JhgmY5q.jpg",
                                                           id: 1,
                                                           title: "Furiosa: A Mad Max Saga",
                                                           originalTitle: "Furiosa: A Mad Max Saga",
                                                           originalLanguage: "en",
                                                           overview: "As the world fell, young Furiosa is snatched from the Green Place of Many Mothers and falls into the hands of a great Biker Horde led by the Warlord Dementus. Sweeping through the Wasteland they come across the Citadel presided over by The Immortan Joe. While the two Tyrants war for dominance, Furiosa must survive many trials as she puts together the means to find her way home.",
                                                           posterPath: "http://image.tmdb.org/t/p/w780/iADOJ8Zymht2JPMoy3R7xceZprc.jpg",
                                                           genreIds: [],
                                                           popularity: 6058.314,
                                                           firstAirDate: nil,
                                                           releaseDate: .init(timeIntervalSince1970: 1705899600),
                                                           voteAverage: 7.713,
                                                           voteCount: 1594,
                                                           originCountry: nil,
                                                           rating: 5.2)],
                         totalPages: 1,
                         totalResults: 123)
    }
    
    func getMovieDetails(movieId: Int) async throws -> MovieDetail {
        MovieDetail(adult: true,
                    id: 1,
                    title: "Furiosa: A Mad Max Saga",
                    originalTitle: "Furiosa: A Mad Max Saga",
                    originalLanguage: "en",
                    overview: "As the world fell, young Furiosa is snatched from the Green Place of Many Mothers and falls into the hands of a great Biker Horde led by the Warlord Dementus. Sweeping through the Wasteland they come across the Citadel presided over by The Immortan Joe. While the two Tyrants war for dominance, Furiosa must survive many trials as she puts together the means to find her way home.",
                    genres: [],
                    firstAirDate: .init(timeIntervalSince1970: 1705899600),
                    releaseDate: nil,
                    originCountry: nil,
                    posterPath: "http://image.tmdb.org/t/p/w780/iADOJ8Zymht2JPMoy3R7xceZprc.jpg",
                    backdropPath:"https://image.tmdb.org/t/p/w1280/wNAhuOZ3Zf84jCIlrcI6JhgmY5q.jpg")
    }
    
    func searchForMovie(query: String) async throws -> TrendingResponse {
        TrendingResponse(page: 1, results: [TrendingObject(adult: true,
                                                           backdropPath: "https://image.tmdb.org/t/p/w1280/wNAhuOZ3Zf84jCIlrcI6JhgmY5q.jpg",
                                                           id: 1,
                                                           title: "Furiosa: A Mad Max Saga",
                                                           originalTitle: "Furiosa: A Mad Max Saga",
                                                           originalLanguage: "en",
                                                           overview: "As the world fell, young Furiosa is snatched from the Green Place of Many Mothers and falls into the hands of a great Biker Horde led by the Warlord Dementus. Sweeping through the Wasteland they come across the Citadel presided over by The Immortan Joe. While the two Tyrants war for dominance, Furiosa must survive many trials as she puts together the means to find her way home.",
                                                           posterPath: "http://image.tmdb.org/t/p/w780/iADOJ8Zymht2JPMoy3R7xceZprc.jpg",
                                                           genreIds: [],
                                                           popularity: 6058.314,
                                                           firstAirDate: nil,
                                                           releaseDate: .init(timeIntervalSince1970: 1705899600),
                                                           voteAverage: 7.713,
                                                           voteCount: 1594,
                                                           originCountry: nil,
                                                           rating: 5.2)],
                         totalPages: 1,
                         totalResults: 123)
    }
}
