//
//  LoginView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-18.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    
    init(userRepo: UserRepository) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(userRepo: userRepo))
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
            
            SignInWithAppleButton(.signIn) {
                $0.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                Task { await viewModel.handle(appleAuthResult: result) }
            }
            .signInWithAppleButtonStyle(.whiteOutline)
            .frame(height: 50)
        }
        .padding()
    }
}

#Preview {
    LoginView(userRepo: UserRepository(environment: .development))
}
