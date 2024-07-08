//
//  AddRatingView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-05.
//

import SwiftUI

struct AddRatingView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var addRatingViewModel: AddRatingViewModel
    
    init(viewModel: AddRatingViewModel) {
        _addRatingViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(addRatingViewModel.formattedRating)
                Slider(value: $addRatingViewModel.rating, in: 0...10, step: 1)
                TextField("Comment", text: $addRatingViewModel.comment, axis: .vertical)
                    .lineLimit(5)
                Button(action: {
                    Task {
                        await addRatingViewModel.saveRating()
                    }
                }, label: {
                    Text("Save")
                })
                    
            }
            .padding()
            .navigationTitle("Add Rating")
            .toolbar {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Done")
                })
            }
            .onReceive(addRatingViewModel.$commentSaved, perform: { commentSaved in
                if commentSaved {
                    dismiss()
                }
            })
        }
    }
}

#Preview {
    AddRatingView(viewModel: AddRatingViewModel(movieId: 0, userRepo: UserRepository()))
}
