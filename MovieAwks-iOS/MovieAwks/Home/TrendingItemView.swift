//
//  TrendingItemView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-02.
//

import SwiftUI

struct TrendingItemView: View {
    
    let trendingItem: TrendingObject
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(trendingItem.title ?? "")
                .font(.title3)
            AsyncImage(url: try? trendingItem.posterPath?.asURL()) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 300)
            Text(trendingItem.overview ?? "")
        }
    }
}


#Preview {
    TrendingItemView(trendingItem: TrendingObject(adult: true,
                                                  backdropPath: "/wNAhuOZ3Zf84jCIlrcI6JhgmY5q.jpg",
                                                  id: 1,
                                                  title: "Furiosa: A Mad Max Saga",
                                                  originalTitle: "Furiosa: A Mad Max Saga",
                                                  originalLanguage: "en",
                                                  overview: "As the world fell, young Furiosa is snatched from the Green Place of Many Mothers and falls into the hands of a great Biker Horde led by the Warlord Dementus. Sweeping through the Wasteland they come across the Citadel presided over by The Immortan Joe. While the two Tyrants war for dominance, Furiosa must survive many trials as she puts together the means to find her way home.",
                                                  posterPath: "https://image.tmdb.org/t/p/w300/iADOJ8Zymht2JPMoy3R7xceZprc.jpg",
                                                  mediaType: .movie,
                                                  genreIds: [],
                                                  popularity: 6058.314,
                                                  firstAirDate: nil,
                                                  releaseDate: .init(timeIntervalSince1970: 1705899600),
                                                  voteAverage: 7.713,
                                                  voteCount: 1594,
                                                  originCountry: nil))
}


