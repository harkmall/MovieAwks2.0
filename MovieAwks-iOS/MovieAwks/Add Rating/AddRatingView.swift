//
//  AddRatingView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-05.
//

import SwiftUI

struct AddRatingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
            .navigationTitle("Add Rating")
            .onReceive(viewModel.$commentSaved, perform: { commentSaved in
                if commentSaved {
                    dismiss()
                }
            })
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
        }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private var idleView: some View {
        VStack {
            Spacer()
            
            Text(viewModel.formattedRating)
                .font(.largeTitle)
            
            Slider(value: $viewModel.rating, in: 0...10, step: 0.5)
            
            TextField("Comment", text: $viewModel.comment, axis: .vertical)
                .lineLimit(5)
            
            Spacer()
            
            Button(action: {
                Task { await viewModel.saveRating() }
            }, label: {
                Text("Save")
            })
                
        }
        .padding()
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
            Button(action: {
                Task {
                    await viewModel.saveRating()
                }
            }, label: {
                Text("Retry")
            })
        }
    }
}

#Preview {
    AddRatingView(viewModel: AddRatingView.ViewModel(movieId: 0))
}
