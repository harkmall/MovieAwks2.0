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
    @State private var readMore = true
    
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
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
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
            contentList
        }
    }
    
    @ViewBuilder
    private var contentList: some View {
        List {
            Section {
                detailHeader
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            switch viewModel.state.1 {
            case .loading:
                loadingView
            case .error(let error):
                errorView(error: error) { await viewModel.getMovieRatings() }
            case .success(let averageRating, let totalRatings, let ratings):
                if ratings.isEmpty {
                    Section {
                        Text("No Ratings")
                    }
                } else {
                    Section {
                        Text(averageRating)
                            .font(.title)
                        Text("Total Ratings: " + totalRatings)
                            .font(.subheadline)
                    }
                    .listRowSeparator(.hidden)
                    
                    Section("Ratings") {
                        ForEach(ratings, id: \.id) { movieRating in
                            RatingItemView(movieRating: movieRating)
                        }
                    }
                }
                
            }
        }

    }
    
    @ViewBuilder
    private var detailHeader: some View {
        switch viewModel.state.0 {
        case .loading:
            loadingView
        case .error(let error):
            errorView(error: error) { await viewModel.getMovieDetails() }
        case .success(let movieDetail):
            detailHeaderView(with: movieDetail)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(movieDetail.title ?? "")
        }
    }
    
    private func detailHeaderView(with details: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                AsyncImage(url: try? details.posterPath?.asURL()) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                Spacer()
            }
            
            if let releaseDate = details.releaseDate?.formatted(date: .abbreviated,
                                                                time: .omitted) {
                Text(releaseDate)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
            
            if let overview = details.overview {
                VStack(alignment: .leading) {
                    Text(overview)
                        .font(.subheadline)
                        .lineLimit(readMore ? 4 : 20)
                        .fixedSize(horizontal: false, vertical: true)
                    Button(readMore ? "Read More" : "Read Less" ) {
                        readMore.toggle()
                    }
                    .font(.subheadline)
                }
            }
            
            ScrollView {
                HStack {
                    ForEach(details.genres, id:\.id) { genre in
                        Text(genre.name)
                            .foregroundStyle(.primary)
                            .font(.footnote)
                            .italic()
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 2).fill(Color.secondary.opacity(0.2)))
                    }
                }
            }
        }
    }
    
    private func errorView(error: Error...,
                           retryTask: @Sendable @escaping () async -> Void ) -> some View {
        HStack {
            Spacer()
            VStack {
                Text(error.reduce("", { $0.appending($1.localizedDescription) + "\n" }))
                Button(action: {
                    Task(operation: retryTask)
                }, label: {
                    Text("Retry")
                })
            }
            Spacer()
        }
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(viewModel: DetailView.ViewModel(itemId: 786892,
                                                   tmdbService: Mock_TMDBService(networkingManager: .current),
                                                   movieRatingsService: Mock_MovieRatingsService(networkingManager: .current)))
        .environmentObject(UserRepository())
    }
}
