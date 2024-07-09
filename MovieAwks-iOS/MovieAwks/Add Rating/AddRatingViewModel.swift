//
//  AddRatingViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-08.
//

import Foundation
import Combine

@MainActor
class AddRatingViewModel: ObservableObject {
    private let movieId: Int
    private let userRepo: UserRepository
    private let movieRatingsService: MovieRatingsServiceType
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var comment: String = ""
    @Published var rating: Float = 0
    @Published var formattedRating: String = ""
    @Published var commentSaved = false
    @Published var error: Error?
    
    init(movieId: Int,
         userRepo: UserRepository,
         movieRatingsService: MovieRatingsServiceType = MovieRatingsService(networkingManager: .current)) {
        self.movieId = movieId
        self.movieRatingsService = movieRatingsService
        self.userRepo = userRepo
        
        $rating
            .map { $0.formatted() }
            .assign(to: \.formattedRating, on: self)
            .store(in: &cancellables)
    }
    
    func saveRating() async {
        guard let accessToken = userRepo.accessToken else {
            error = APIError.identityTokenMissing
            return
        }
        do {
            try await movieRatingsService.saveMovieRating(accessToken: accessToken,
                                                          with: MovieRatingRequestBody(movieId: movieId,
                                                                                       rating: rating,
                                                                                       comment: comment.isEmpty ? nil : comment))
            commentSaved = true
        } catch {
            self.error = error
        }
    }
}
