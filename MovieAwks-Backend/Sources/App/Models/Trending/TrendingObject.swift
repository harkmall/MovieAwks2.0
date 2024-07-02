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
}

// MARK: - Image URLs

//last one should be "original", so get the one before "original"
extension TrendingObject {
    mutating func buildImageUrls(with configuration: ImagesConfiguration) {
        buildBackdropUrl(with: configuration)
        buildPosterPath(with: configuration)
    }
    
    private mutating func buildBackdropUrl(with configuration: ImagesConfiguration) {
        let backdropSizeIndex = (configuration.backdropSizes?.count ?? 2) - 2
        let backdropSize = configuration.backdropSizes?[backdropSizeIndex] ?? ""
        
        backdropPath = (configuration.secureBaseUrl ?? "") + (backdropSize) + (backdropPath ?? "")
    }
    
    private mutating func buildPosterPath(with configuration: ImagesConfiguration) {
        let posterSizeIndex = (configuration.posterSizes?.count ?? 2) - 2
        let posterSize = configuration.posterSizes?[posterSizeIndex] ?? ""
        
        posterPath = (configuration.secureBaseUrl ?? "") + (posterSize) + (posterPath ?? "")
    }
}
