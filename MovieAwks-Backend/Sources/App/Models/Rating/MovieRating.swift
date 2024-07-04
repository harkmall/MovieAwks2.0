//
//  MovieRating.swift
//
//
//  Created by Mark Hall on 2024-07-04.
//

import Foundation
import Vapor
import Fluent

final class MovieRating: Model, Content {
    static let schema = "movieRatings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "movieId")
    var movieId: Int
    
    @Field(key: "rating")
    var rating: Float
    
    @Field(key: "comment")
    var comment: String?
    
    init() { }
    
    init(user: User, publicObject: Public) throws {
        self.id = nil
        self.$user.id = try user.requireID()
        self.movieId = publicObject.movieId
        self.rating = publicObject.rating
        self.comment = publicObject.comment
    }
}

extension MovieRating {
    struct Public: Content {
        let movieId: Int
        let rating: Float
        let comment: String?
    }
}
