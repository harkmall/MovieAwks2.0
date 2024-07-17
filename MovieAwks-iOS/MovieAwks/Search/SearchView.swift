//
//  SearchView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-15.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Search")
                .searchable(text: $viewModel.searchText)
                .onChange(of: viewModel.debouncedSearchText, { _, _ in
                    Task { await viewModel.search() }
                })
                .onSubmit(of: .search) {
                    Task { await viewModel.search() }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            idleView
        case .loading:
            loadingView
        case .error(let error):
            errorView(error: error)
        case .success(let items):
            successView(items: items)
        }
    }
    
    private var idleView: some View {
        Text("Search")
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
            Button(action: {
                Task { await viewModel.search() }
            }, label: {
                Text("Retry")
            })
        }
    }
    
    private func successView(items: [TrendingObject]) -> some View {
        List(items, id: \.id) { searchResult in
            NavigationLink(destination: DetailView(viewModel: DetailView.ViewModel(itemId: searchResult.id))) {
                SearchItemView(searchObject: searchResult)
            }
        }
    }
}

#Preview {
    SearchView(viewModel: SearchView.ViewModel())
}
