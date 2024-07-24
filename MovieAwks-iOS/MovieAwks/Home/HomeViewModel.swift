//
//  HomeViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation
import Combine

extension HomeView {
    @MainActor
    class ViewModel: ObservableObject {
        enum State {
            case loading
            case success(trendingItems: [TrendingObject])
            case error(error: Error)
        }
        
        private let tmdbService: TMDBServiceType
        
        private var page = 1 //TODO: handle pagination
        
        @Published var state: State = .loading
        @Published var trendingItems: [TrendingObject] = []
        
        init(tmdbService: TMDBServiceType = TMDBService(networkingManager: .current)) {
            self.tmdbService = tmdbService
        }
        
        func getTrendingItems(reload: Bool = false) async {
            if !reload { self.state = .loading }
            do {
                let trendingResponse = try await self.tmdbService
                    .getTrending(type: .movie,
                                 timeFrame: .week,
                                 page: self.page)
                state = .success(trendingItems: trendingResponse.results)
            } catch {
                state = .error(error: error)
            }
            
        }
    }
}
