//
//  HomeViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    private let userRepo: UserRepository
    private let tmdbService: TMDBServiceType
    private var cancellables: Set<AnyCancellable> = []
    
    private var page = 1
    
    @Published var name: String = ""
    @Published var trendingItems: [TrendingObject] = []
    @Published var error: Error?
    
    init(userRepository: UserRepository,
         tmdbService: TMDBServiceType = TMDBService(environment: .current)) {
        self.userRepo = userRepository
        self.tmdbService = tmdbService
        
        userRepository.$user
            .compactMap { "\($0?.firstName ?? "") \($0?.lastName ?? "")" }
            .assign(to: \.name, on: self)
            .store(in: &cancellables)
        
    }
    
    func getUser() async throws {
        try await self.userRepo.getUser()
    }
    
    func logoutUser() {
        self.userRepo.logoutUser()
    }
    
    func getTrendingItems() async {
        guard let accessToken = userRepo.accessToken else {
            await MainActor.run {
                self.error = APIError.identityTokenMissing
            }
            return
        }
        
        do {
            let trendingResponse = try await self.tmdbService
                .getTrending(accessToken: accessToken,
                             type: .movie,
                             timeFrame: .week,
                             page: self.page)
            await MainActor.run {
                self.trendingItems = trendingResponse.results
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
        
    }
}
