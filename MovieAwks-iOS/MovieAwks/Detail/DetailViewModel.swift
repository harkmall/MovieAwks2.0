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
        enum State {
            enum Details {
                case loading
                case success(movieDetail: MovieDetail)
                case error(error: Error)
            }
            enum Ratings {
                case loading
                case success(averageRating: String, totalRatings: String, ratings: [MovieRating])
                case error(error: Error)
            }
        }
        
        private let tmdbService: TMDBServiceType
        private let movieRatingsService: MovieRatingsServiceType
        let itemId: Int

        @Published var state: (State.Details, State.Ratings) = (.loading, .loading)

        init(itemId: Int,
             tmdbService: TMDBServiceType = TMDBService(networkingManager: .current),
             movieRatingsService: MovieRatingsServiceType = MovieRatingsService(networkingManager: .current)) {
            self.tmdbService = tmdbService
            self.movieRatingsService = movieRatingsService
            self.itemId = itemId
        }
        
        func getMovieDetails() async {
            state = (.loading, state.1)
            do {
                let movieDetails = try await self.tmdbService
                    .getMovieDetails(movieId: itemId)
                state = (.success(movieDetail: movieDetails), state.1)
            } catch {
                state = (.error(error: error), state.1)
            }
        }
        
        func getMovieRatings() async {
            state = (state.0, .loading)
            do {
                let movieRatingsResponse = try await self.movieRatingsService
                    .getRatings(forMovie: itemId)
                state = (state.0, .success(averageRating: movieRatingsResponse.averageRating.emojiRating,
                                           totalRatings: movieRatingsResponse.totalRatings.formatted(.number),
                                           ratings: movieRatingsResponse.ratings))
            } catch {
                state = (state.0, .error(error: error))
            }
        }
    }
}
