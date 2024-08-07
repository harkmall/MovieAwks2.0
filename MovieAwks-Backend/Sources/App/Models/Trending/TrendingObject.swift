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
    let id: Int
    let title: String?
    let originalTitle: String?
    let originalLanguage: String?
    let overview: String?
    let mediaType: MediaType
    let genreIds: [Int]
    let popularity: Float
    let firstAirDate: Date? //YYYY-MM-DD
    let releaseDate: Date? //YYYY-MM-DD
    var video: Bool? = false
    let voteAverage: Float
    let voteCount: Int
    let originCountry: [String]?
    var posterPath: String?
    var backdropPath: String?
    var rating: Float?
}

// MARK: - Image URLs
extension TrendingObject: ImagePathBuildable { }
