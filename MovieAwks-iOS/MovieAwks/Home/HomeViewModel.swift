//
//  HomeViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    let userRepo: UserRepository
    private let tmdbService: TMDBServiceType
    private var cancellables: Set<AnyCancellable> = []
    
    private var page = 1
    
    @Published var trendingItems: [TrendingObject] = []
    @Published var error: Error?
    
    init(userRepository: UserRepository,
         tmdbService: TMDBServiceType = TMDBService(networkingManager: .current)) {
        self.userRepo = userRepository
        self.tmdbService = tmdbService
    }
    
    func getUser() async throws {
        try await self.userRepo.getUser()
    }
    
    func logoutUser() {
        self.userRepo.logoutUser()
    }
    
    func getTrendingItems() async {
        guard let accessToken = userRepo.accessToken else {
            self.error = APIError.identityTokenMissing
            return
        }
        
        do {
            let trendingResponse = try await self.tmdbService
                .getTrending(accessToken: accessToken,
                             type: .movie,
                             timeFrame: .week,
                             page: self.page)
            self.trendingItems = trendingResponse.results
        } catch {
            self.error = error
        }
        
    }
}
