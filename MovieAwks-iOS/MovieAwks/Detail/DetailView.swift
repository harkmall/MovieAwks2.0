//
//  DetailView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var detailViewModel: DetailViewModel
    
    init(detailViewModel: DetailViewModel) {
        _detailViewModel = StateObject(wrappedValue: detailViewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
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
        .onAppear {
            Task {
                await detailViewModel.getMovieRatings()
            }
        }
    }
}

#Preview {
    DetailView(detailViewModel: DetailViewModel(itemId: 0,
                                                userRepo: UserRepository(),
                                                movieRatingsService: MovieRatingsService(environment: .current)))
}
