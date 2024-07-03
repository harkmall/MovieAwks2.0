//
//  DetailViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import Foundation

class DetailViewModel: ObservableObject {
    private let userRepo: UserRepository
    private let tmdbService: TMDBServiceType
    
    init(itemId: String,
         userRepo: UserRepository,
         tmdbService: TMDBServiceType = TMDBService(environment: .current)) {
        self.userRepo = userRepo
        self.tmdbService = tmdbService
    }
}
