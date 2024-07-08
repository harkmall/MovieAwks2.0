//
//  DetailViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import Foundation

class DetailViewModel: ObservableObject {
    let userRepo: UserRepository
    private let tmdbService: TMDBServiceType
    private let movieRatingsService: MovieRatingsServiceType
    let itemId: Int
    
    @Published var averageRating: String = ""
    @Published var totalRatings: String = ""
    @Published var movieRatings: [MovieRating] = []
    @Published var movieDetails: MovieDetail?
    @Published var error: Error?
    
    init(itemId: Int,
         userRepo: UserRepository,
         tmdbService: TMDBServiceType = TMDBService(environment: .current),
         movieRatingsService: MovieRatingsServiceType = MovieRatingsService(environment: .current)) {
        self.userRepo = userRepo
        self.tmdbService = tmdbService
        self.movieRatingsService = movieRatingsService
        self.itemId = itemId
    }
    
    func getMovieDetails() async {
        guard let accessToken = userRepo.accessToken else {
            await MainActor.run {
                self.error = APIError.identityTokenMissing
            }
            return
        }
        
        do {
            let movieDetails = try await self.tmdbService
                .getMovieDetails(accessToken: accessToken,
                                 movieId: itemId)
            await MainActor.run {
                self.movieDetails = movieDetails
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
    
    func getMovieRatings() async {
        guard let accessToken = userRepo.accessToken else {
            await MainActor.run {
                self.error = APIError.identityTokenMissing
            }
            return
        }
        
        do {
            let movieRatingsResponse = try await self.movieRatingsService
                .getRatings(accessToken: accessToken,
                            forMovie: itemId)
            await MainActor.run {
                self.movieRatings = movieRatingsResponse.ratings
                self.averageRating = movieRatingsResponse.averageRating.formatted()
                self.totalRatings = movieRatingsResponse.totalRatings.formatted(.number)
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
}
