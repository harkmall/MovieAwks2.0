//
//  DetailView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel: ViewModel
    @State private var showAddRating = false
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        Task {
            await [viewModel.getMovieRatings(), viewModel.getMovieDetails()]
        }
    }
    
    var body: some View {
        VStack {
            content
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    showAddRating.toggle()
                }, label: {
                    Image(systemName: "plus.square")
                })
            }
        }
        .sheet(isPresented: $showAddRating, onDismiss: {
            Task {
                await viewModel.getMovieRatings()
            }
        }, content: {
            AddRatingView(viewModel: AddRatingView.ViewModel(movieId: viewModel.itemId))
        })
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case (.error(let detailError), .error(error: let ratingsError)):
            errorView(error: detailError, ratingsError) {
                Task { await [viewModel.getMovieRatings(), viewModel.getMovieDetails()] }
            }
        case (.loading, .loading):
            loadingView
        default:
            detailContent
            ratingsContent
        }
    }
    
    @ViewBuilder
    private var detailContent: some View {
        switch viewModel.state.0 {
        case .loading:
            loadingView
        case .error(let error):
            errorView(error: error) { await viewModel.getMovieDetails() }
        case .success(let movieDetail):
            movieDetailsView(with: movieDetail)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(movieDetail.title ?? "")
        }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private func errorView(error: Error..., retryTask: @Sendable @escaping () async -> Void ) -> some View {
        VStack {
            Text(error.reduce("", { $0.appending($1.localizedDescription) + "\n" }))
            Button(action: {
                Task(operation: retryTask)
            }, label: {
                Text("Retry")
            })
        }
    }
    
    private func movieDetailsView(with details: MovieDetail) -> some View {
        VStack(alignment: .leading) {
            AsyncImage(url: try? details.posterPath?.asURL()) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
            Text(details.overview ?? "")
                .font(.subheadline)
        }
        .padding()
    }
    
    @ViewBuilder
    private var ratingsContent: some View {
        switch viewModel.state.1 {
        case .loading:
            loadingView
        case .error(let error):
            errorView(error: error) { await viewModel.getMovieRatings() }
        case .success(let averageRating, let totalRatings, let ratings):
            ratingsView(with: averageRating, totalRatings: totalRatings, ratings: ratings)
        }
    }
    
    private func ratingsView(with averageRating: String, totalRatings: String, ratings: [MovieRating] ) -> some View {
        VStack {
            Text(averageRating)
                .font(.title)
            Text("Total Ratings: " + totalRatings)
                .font(.subheadline)
            List(ratings, id: \.id) { movieRating in
                RatingItemView(movieRating: movieRating)
            }
        }
    }
}

#Preview {
    DetailView(viewModel: DetailView.ViewModel(itemId: 786892,
                                               movieRatingsService: MovieRatingsService(networkingManager: .current)))
    .environmentObject(UserRepository())
}
