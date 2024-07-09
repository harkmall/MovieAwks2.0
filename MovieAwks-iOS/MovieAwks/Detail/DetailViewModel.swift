//
//  DetailViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import Foundation

extension DetailView {
    @MainActor
    class ViewModel: ObservableObject {
        private let tmdbService: TMDBServiceType
        private let movieRatingsService: MovieRatingsServiceType
        let itemId: Int
        
        @Published var averageRating: String = ""
        @Published var totalRatings: String = ""
        @Published var movieRatings: [MovieRating] = []
        @Published var movieDetails: MovieDetail?
        @Published var error: Error?
        
        init(itemId: Int,
             tmdbService: TMDBServiceType = TMDBService(networkingManager: .current),
             movieRatingsService: MovieRatingsServiceType = MovieRatingsService(networkingManager: .current)) {
            self.tmdbService = tmdbService
            self.movieRatingsService = movieRatingsService
            self.itemId = itemId
        }
        
        func getMovieDetails() async {
            do {
                let movieDetails = try await self.tmdbService
                    .getMovieDetails(movieId: itemId)
                self.movieDetails = movieDetails
            } catch {
                self.error = error
            }
        }
        
        func getMovieRatings() async {
            do {
                let movieRatingsResponse = try await self.movieRatingsService
                    .getRatings(forMovie: itemId)
                self.movieRatings = movieRatingsResponse.ratings
                self.averageRating = movieRatingsResponse.averageRating.formatted()
                self.totalRatings = movieRatingsResponse.totalRatings.formatted(.number)
            } catch {
                self.error = error
            }
        }
    }
}
