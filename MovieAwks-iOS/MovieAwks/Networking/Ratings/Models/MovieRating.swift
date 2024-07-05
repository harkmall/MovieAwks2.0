//
//  MovieRating.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-05.
//

import Foundation

final class MovieRating: Codable {
    let id: UUID?
    let user: User
    let createdAt: Date?
    let movieId: Int
    let rating: Float
    let comment: String?
}
