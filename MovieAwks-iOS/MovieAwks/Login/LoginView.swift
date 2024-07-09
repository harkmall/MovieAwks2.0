//
//  LoginView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-18.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(userRepo: UserRepository) {
        _viewModel = StateObject(wrappedValue: ViewModel(userRepo: userRepo))
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 8) {
                Text("MovieAwks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("How awkward is it going to be to watch this movie with my parents")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
            
            content
        }
        .padding()
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .idle:
            idleView
        case .error(let error):
            errorView(error: error)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private var idleView: some View {
        SignInWithAppleButton(.signIn) {
            $0.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            Task { await viewModel.handle(appleAuthResult: result) }
        }
        .signInWithAppleButtonStyle(.whiteOutline)
        .frame(height: 50)
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
                .foregroundStyle(.red)
            
            idleView
        }
    }
}

#Preview {
    LoginView(userRepo: UserRepository())
}
