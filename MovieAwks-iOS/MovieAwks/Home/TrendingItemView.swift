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
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .center) {
                    AsyncImage(url: try? trendingItem.posterPath?.asURL()) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100)
                            .padding()
                    }
                    .frame(height: 200)
                    
                    Text(trendingItem.emojiRating)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray))
                }
                
                Text(trendingItem.title ?? "")
                    .font(.title3)
                    .bold()
                Spacer()
            }
        }
    }
}


#Preview {
    List {
        TrendingItemView(trendingItem: TrendingObject(title: "Furiosa: A Mad Max Saga",
                                                      posterPath: "https://image.tmdb.org/t/p/w300/iADOJ8Zymht2JPMoy3R7xceZprc.jpg",
                                                      backdropPath: "https://image.tmdb.org/t/p/w1280/wNAhuOZ3Zf84jCIlrcI6JhgmY5q.jpg",
                                                      rating: 5.2))
        .border(Color.black)
        
        TrendingItemView(trendingItem: TrendingObject(title: "Kingdom of the Planet of the Apes",
                                                      posterPath: "https://image.tmdb.org/t/p/w780/gKkl37BQuKTanygYQG1pyYgLVgf.jpg",
                                                      backdropPath: "https://image.tmdb.org/t/p/w1280/gKkl37BQuKTanygYQG1pyYgLVgf.jpg",
                                                      rating: 9))
        .border(Color.black)
    }
}


