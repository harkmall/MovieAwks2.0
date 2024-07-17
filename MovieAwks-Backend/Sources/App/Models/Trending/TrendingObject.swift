//
//  TrendingObject.swift
//
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation
import Vapor

struct TrendingObject: Content {
    let adult: Bool
    let id: Int
    let title: String?
    let originalTitle: String?
    let originalLanguage: String?
    let overview: String?
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.popularity = try container.decode(Float.self, forKey: .popularity)
        self.firstAirDate = try container.decodeIfPresent(Date.self, forKey: .firstAirDate)
        //sometimes the release date is an empty string (I think for unreleased movies) which is annoying, why not make it `null`... but whatever
        self.releaseDate = try? container.decodeIfPresent(Date.self, forKey: .releaseDate)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
        self.originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.rating = try container.decodeIfPresent(Float.self, forKey: .rating)
    }
}

// MARK: - Image URLs
extension TrendingObject: ImagePathBuildable { }
