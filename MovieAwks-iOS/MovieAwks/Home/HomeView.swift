//
//  HomeView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var userRepository: UserRepository
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Trending")
                .toolbar {
                    ToolbarItem {
                        NavigationLink(destination: ProfileView(viewModel: .init(userRepo: userRepository))) {
                            Image(systemName: "person")
                        }
                    }
                }
        }
        .task {
            Task {
                await viewModel.getTrendingItems()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .success(let trendingItems):
            successView(trendingItems: trendingItems)
        case .error(let error):
            errorView(error: error)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
            Button(action: {
                Task {
                    await viewModel.getTrendingItems()
                }
            }, label: {
                Text("Retry")
            })
        }
    }
    
    private func successView(trendingItems: [TrendingObject]) -> some View {
        let columns = Array(repeating: GridItem(), count: 2)
        
        return ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(trendingItems, id: \.id) { trendingItem in
                    NavigationLink(destination: DetailView(viewModel: DetailView.ViewModel(itemId: trendingItem.id))) {
                        TrendingItemView(trendingItem: trendingItem)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .refreshable {
            await viewModel.getTrendingItems(reload: true)
        }
    }
}

#Preview {
    HomeView(viewModel: HomeView.ViewModel(tmdbService: Mock_TMDBService(networkingManager: .current)))
        .environmentObject(UserRepository())
}
