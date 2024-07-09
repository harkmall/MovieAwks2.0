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
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                AsyncImage(url: try? viewModel.movieDetails?.posterPath?.asURL()) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                Text(viewModel.movieDetails?.overview ?? "")
                    .font(.subheadline)
            }
            
            Text("Average: " + viewModel.averageRating)
                .font(.title)
            Text("Total Ratings: " + viewModel.totalRatings)
                .font(.subheadline)
            List(viewModel.movieRatings, id: \.id) { movieRating in
                VStack {
                    Text("\(movieRating.rating)")
                    Text(movieRating.user.firstName ?? "...")
                    Text(movieRating.comment ?? "-")
                    Text(movieRating.createdAt?.formatted() ?? "---")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.movieDetails?.title ?? "")
        .toolbar {
            ToolbarItem {
                Button(action: {
                    showAddRating.toggle()
                }, label: {
                    Image(systemName: "plus.square")
                })
                
            }
        }
        .onAppear {
            Task {
                await [viewModel.getMovieRatings(), viewModel.getMovieDetails()]
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
}

#Preview {
    DetailView(viewModel: DetailView.ViewModel(itemId: 786892,
                                               movieRatingsService: MovieRatingsService(networkingManager: .current)))
}
