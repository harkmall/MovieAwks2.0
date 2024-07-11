//
//  RatingItemView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-11.
//

import SwiftUI

struct RatingItemView: View {
    let movieRating: MovieRating
    private let formatter = RelativeDateTimeFormatter()
    
    init(movieRating: MovieRating) {
        self.movieRating = movieRating
        formatter.unitsStyle = .short
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Text(movieRating.emojiRating)
                    .font(.headline)
                Spacer()
                if let createdAt = movieRating.createdAt {
                    Text(formatter.localizedString(for: createdAt,
                                                   relativeTo: Date()))
                        .font(.caption2)
                }
            }
            if let comment = movieRating.comment {
                Text(comment)
            }
            if let name = movieRating.user.fullName {
                Text(name)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        RatingItemView(movieRating: MovieRating(id: nil,
                                                user: User(id: .init(),
                                                           email: "email",
                                                           firstName: "Mark",
                                                           lastName: "Hall"),
                                                createdAt: Date().addingTimeInterval(-(24*60)),
                                                movieId: 1234,
                                                rating: 6.9,
                                                comment: "Comment string"))
        
        RatingItemView(movieRating: MovieRating(id: nil,
                                                user: User(id: .init(),
                                                           email: "email",
                                                           firstName: "Mark",
                                                           lastName: nil),
                                                createdAt: Date().addingTimeInterval(-(4*60*60)),
                                                movieId: 1234,
                                                rating: 9,
                                                comment: nil))
    }
    .padding()
}
