//
//  DetailView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var detailViewModel: DetailViewModel
    @State private var showAddRating = false
    
    init(detailViewModel: DetailViewModel) {
        _detailViewModel = StateObject(wrappedValue: detailViewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                AsyncImage(url: try? detailViewModel.movieDetails?.posterPath?.asURL()) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                Text(detailViewModel.movieDetails?.overview ?? "")
                    .font(.subheadline)
            }
            
            Text("Average: " + detailViewModel.averageRating)
                .font(.title)
            Text("Total Ratings: " + detailViewModel.totalRatings)
                .font(.subheadline)
            List(detailViewModel.movieRatings, id: \.id) { movieRating in
                VStack {
                    Text("\(movieRating.rating)")
                    Text(movieRating.user.firstName ?? "...")
                    Text(movieRating.comment ?? "-")
                    Text(movieRating.createdAt?.formatted() ?? "---")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(detailViewModel.movieDetails?.title ?? "")
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
                await [detailViewModel.getMovieRatings(), detailViewModel.getMovieDetails()]
            }
        }
        .sheet(isPresented: $showAddRating, onDismiss: {
            Task {
                await detailViewModel.getMovieRatings()
            }
        }, content: {
            AddRatingView(viewModel: AddRatingViewModel(movieId: detailViewModel.itemId,
                                                        userRepo: detailViewModel.userRepo))
        })
    }
}

#Preview {
    DetailView(detailViewModel: DetailViewModel(itemId: 786892,
                                                userRepo: UserRepository(),
                                                movieRatingsService: MovieRatingsService(environment: .current)))
}
