//
//  MovieAwksApp.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-18.
//

import SwiftUI

@main
struct MovieAwksApp: App {
    
    @StateObject var userRepository = UserRepository(environment: .development)
    
    var body: some Scene {
        WindowGroup {
            if userRepository.accessToken == nil {
                LoginView(userRepo: userRepository)
            } else {
                HomeView()
                    .environmentObject(userRepository)
            }
        }
    }
}
