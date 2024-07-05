//
//  MovieRatingsResponse.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-05.
//

import Foundation

struct MovieRatingsResponse: Codable {
    let ratings: [MovieRating]
    let totalRatings: Int
    let averageRating: Float
}
