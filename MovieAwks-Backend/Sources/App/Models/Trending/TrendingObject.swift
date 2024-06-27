//
//  TrendingObject.swift
//
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation
import Vapor

struct TrendingObject: Content {
    enum MediaType: String, Codable {
        case movie
        case tv
    }
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let name: String?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let posterPath: String?
    let mediaType: MediaType
    let genreIds: [Int]
    let popularity: Float
    let firstAirDate: Date? //YYYY-MM-DD
    let releaseDate: Date? //YYYY-MM-DD
    var video: Bool? = false
    let voteAverage: Float
    let voteCount: Int
    let originCountry: [String]?
}
