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
    let rating: Float?
    let comment: String?
    
    init(id: UUID?, 
         user: User,
         createdAt: Date?,
         movieId: Int,
         rating: Float?,
         comment: String?) {
        self.id = id
        self.user = user
        self.createdAt = createdAt
        self.movieId = movieId
        self.rating = rating
        self.comment = comment
    }
}

extension MovieRating: RatingEmojiRepresentable { }
