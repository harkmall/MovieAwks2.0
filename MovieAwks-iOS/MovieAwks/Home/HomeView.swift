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
            List {
                ForEach(homeViewModel.trendingItems, id: \.id) { item in
                    TrendingItemView(trendingItem: item)
                }
            }
            Spacer()
            Text(self.homeViewModel.name)
            Spacer()
            Button(action: {
                homeViewModel.logoutUser()
            }, label: {
                Text("Logout")
            })
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
