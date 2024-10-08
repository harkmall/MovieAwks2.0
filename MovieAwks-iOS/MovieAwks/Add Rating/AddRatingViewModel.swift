//
//  ViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-08.
//

import Foundation
import Combine

extension AddRatingView {
    @MainActor
    class ViewModel: ObservableObject {
        enum State {
            case idle
            case loading
            case error(error: Error)
        }
        
        private let movieId: Int
        private let movieRatingsService: MovieRatingsServiceType
        
        @Published private(set) var state: State = .idle
        @Published var comment: String = ""
        @Published var rating: Float = 0
        @Published private(set) var formattedRating: String = ""
        @Published private(set) var commentSaved = false
        
        init(movieId: Int,
             movieRatingsService: MovieRatingsServiceType = MovieRatingsService(networkingManager: .current)) {
            self.movieId = movieId
            self.movieRatingsService = movieRatingsService
            
            $rating
                .map { $0.emojiRating }
                .assign(to: &$formattedRating)
        }
        
        func saveRating() async {
            state = .loading
            do {
                try await movieRatingsService.saveMovieRating(with: MovieRatingRequestBody(movieId: movieId,
                                                                                           rating: rating,
                                                                                           comment: comment.isEmpty ? nil : comment))
                commentSaved = true
            } catch {
                state = .error(error: error)
            }
        }
    }
}
