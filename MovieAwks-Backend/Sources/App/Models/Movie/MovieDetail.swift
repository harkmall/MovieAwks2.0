//
//  MovieDetail.swift
//
//
//  Created by Mark Hall on 2024-07-05.
//

import Vapor

struct MovieDetail: Content {
    struct Genre: Content {
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.genres = try container.decode([MovieDetail.Genre].self, forKey: .genres)
        self.firstAirDate = try container.decodeIfPresent(Date.self, forKey: .firstAirDate)
        self.releaseDate = try? container.decodeIfPresent(Date.self, forKey: .releaseDate)
        self.originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    }
}

extension MovieDetail: ImagePathBuildable { }
