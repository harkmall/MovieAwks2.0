//
//  MovieAwksApp.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-18.
//

import SwiftUI

@main
struct MovieAwksApp: App {
    
    static let accessTokenKey = "ACCESS_TOKEN"
    
    @StateObject var userRepository = UserRepository()
    
    var body: some Scene {
        WindowGroup {
            if userRepository.accessToken == nil {
                LoginView(userRepo: userRepository)
            } else {
                TabView {
                    HomeView(viewModel: HomeView.ViewModel())
                        .environmentObject(userRepository)
                        .tabItem {
                            Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
                        }
                    
                    SearchView(viewModel: SearchView.ViewModel())
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                }
            }
        }
    }
}
