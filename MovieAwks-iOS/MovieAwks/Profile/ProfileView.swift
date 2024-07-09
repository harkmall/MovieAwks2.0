//
//  ProfileView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Profile")
        }
        .onAppear {
            Task {
                await viewModel.getUser()
            }
        }
        
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .success:
            successView
        case .error(let error):
            errorView(error: error)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private var successView: some View {
        VStack {
            Text(viewModel.name)
            Button(action: {
                viewModel.logoutUser()
            }, label: {
                Text("Logout")
            })
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
            Button(action: {
                Task {
                    await viewModel.getUser()
                }
            }, label: {
                Text("Retry")
            })
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileView.ViewModel(userRepo: UserRepository()))
}
