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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DetailView(detailViewModel: DetailViewModel(itemId: "",
                                                userRepo: UserRepository()))
}
