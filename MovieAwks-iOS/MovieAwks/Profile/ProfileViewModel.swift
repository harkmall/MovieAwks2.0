//
//  ProfileViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import Foundation
import Combine

extension ProfileView {
    @MainActor
    class ViewModel: ObservableObject {
        
        enum State {
            case loading
            case success
            case error(error: Error)
        }
        
        private let userRepo: UserRepository
        
        @Published var state: State = .loading
        @Published var name: String = ""
        
        init(userRepo: UserRepository) {
            self.userRepo = userRepo
            
            userRepo.$user
                .compactMap { $0?.fullName }
                .assign(to: &$name)
        }
        
        func getUser() async {
            self.state = .loading
            do {
                try await userRepo.getUser()
                self.state = .success
            } catch {
                self.state = .error(error: error)
            }
        }
        
        func logoutUser() {
            userRepo.logoutUser()
        }
    }
}
