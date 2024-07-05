//
//  MovieDetail.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-05.
//

import Foundation

struct MovieDetail: Codable {
    struct Genre: Codable {
        let id: Int
        let name: String
    }
    let adult: Bool
    let id: Int
    let title: String?
    let originalTitle: String?
    let originalLanguage: String?
    let overview: String?
    let genres: [Genre]
    let firstAirDate: Date? //YYYY-MM-DD
    let releaseDate: Date? //YYYY-MM-DD
    let originCountry: [String]?
    var posterPath: String?
    var backdropPath: String?
}
