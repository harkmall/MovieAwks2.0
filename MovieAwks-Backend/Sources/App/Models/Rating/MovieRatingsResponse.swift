//
//  MovieRatingsResponse.swift
//
//
//  Created by Mark Hall on 2024-07-04.
//

import Vapor

struct MovieRatingsResponse: Content {
    let ratings: [MovieRating]
    let totalRatings: Int
    let averageRating: Float
}
