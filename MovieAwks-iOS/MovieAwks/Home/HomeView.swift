//
//  HomeView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
    }
    
    var body: some View {
        VStack {
            NavigationStack{
                List(homeViewModel.trendingItems, id: \.id) { trendingItem in
                    NavigationLink(destination: DetailView(detailViewModel: DetailViewModel(itemId: trendingItem.id,
                                                                                            userRepo: homeViewModel.userRepo))) {
                        TrendingItemView(trendingItem: trendingItem)
                    }
                }
                .navigationTitle("Trending")
                .toolbar {
                    ToolbarItem {
                        NavigationLink(destination: ProfileView(profileViewModel: .init(userRepo: homeViewModel.userRepo))) {
                            Image(systemName: "person")
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            Task {
                await [try homeViewModel.getUser(), homeViewModel.getTrendingItems()]
            }
        })
    }
}

#Preview {
    HomeView(homeViewModel: HomeViewModel(userRepository: UserRepository()))
}
