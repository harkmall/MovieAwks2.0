//
//  SearchViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-15.
//

import Foundation

extension SearchView {
    @MainActor
    class ViewModel: ObservableObject {
        enum State {
            case idle
            case loading
            case success(items: [TrendingObject])
            case error(error: Error)
        }
        
        @Published private(set) var state: State = .idle
        @Published private(set) var debouncedSearchText = ""
        @Published var searchText = ""
        
        private let tmdbService: TMDBServiceType
        
        init(tmdbService: TMDBServiceType = TMDBService(networkingManager: .current)) {
            self.tmdbService = tmdbService
            $searchText
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
                .filter { $0.count >= 3 }
                .assign(to: &$debouncedSearchText)
        }
        
        func search() async {
            self.state = .loading
            do {
                let searchResponse = try await tmdbService.searchForMovie(query: searchText)
                self.state = .success(items: searchResponse.results)
            } catch (let error) {
                self.state = .error(error: error)
            }
        }
    }
}
