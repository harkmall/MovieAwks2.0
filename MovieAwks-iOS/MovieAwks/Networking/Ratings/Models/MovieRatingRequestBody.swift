//
//  MovieRatingRequestBody.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-08.
//

import Foundation

struct MovieRatingRequestBody: Codable {
    let movieId: Int
    let rating: Float
    let comment: String?
}
