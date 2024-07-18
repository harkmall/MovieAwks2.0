//
//  TrendingObject.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation

struct TrendingObject: Codable {
    enum MediaType: String, Codable {
        case movie
        case tv
    }
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let title: String?
    let originalTitle: String?
    let originalLanguage: String?
    let overview: String?
    let posterPath: String?
    //    let mediaType: MediaType
    let genreIds: [Int]
    let popularity: Float
    let firstAirDate: Date? //YYYY-MM-DD
    let releaseDate: Date? //YYYY-MM-DD
    var video: Bool? = false
    let voteAverage: Float
    let voteCount: Int
    let originCountry: [String]?
    let rating: Float?
    
    init(title: String,
         posterPath: String,
         backdropPath: String,
         rating: Float) {
        self.init(adult: false,
                  backdropPath: backdropPath,
                  id: 1,
                  title: title,
                  originalTitle: title,
                  originalLanguage: nil,
                  overview: nil,
                  posterPath: posterPath,
                  genreIds: [],
                  popularity: 0,
                  firstAirDate: nil,
                  releaseDate: nil,
                  voteAverage: 0,
                  voteCount: 0,
                  originCountry: nil,
                  rating: rating)
        
    }
    
    init(adult: Bool,
         backdropPath: String?,
         id: Int,
         title: String?,
         originalTitle: String?,
         originalLanguage: String?,
         overview: String?,
         posterPath: String?,
         genreIds: [Int],
         popularity: Float,
         firstAirDate: Date?,
         releaseDate: Date?,
         video: Bool? = nil,
         voteAverage: Float,
         voteCount: Int,
         originCountry: [String]?,
         rating: Float?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.posterPath = posterPath
        self.genreIds = genreIds
        self.popularity = popularity
        self.firstAirDate = firstAirDate
        self.releaseDate = releaseDate
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.originCountry = originCountry
        self.rating = rating
    }
    
}

extension TrendingObject {
    
}

extension TrendingObject: RatingEmojiRepresentable { }
