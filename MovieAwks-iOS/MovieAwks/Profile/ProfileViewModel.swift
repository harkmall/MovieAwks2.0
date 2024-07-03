//
//  ProfileViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    private let userRepo: UserRepository
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var name: String = ""
    
    init(userRepo: UserRepository) {
        self.userRepo = userRepo
        
        userRepo.$user
            .compactMap { "\($0?.firstName ?? "") \($0?.lastName ?? "")" }
            .assign(to: \.name, on: self)
            .store(in: &cancellables)
    }
    
    func logoutUser() {
        self.userRepo.logoutUser()
    }
}
