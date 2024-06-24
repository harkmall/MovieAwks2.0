//
//  LoginView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-18.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Auth successful")
                    guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential,
                          let identityToken = credentials.identityToken else { return }
                    Task {
                        _ = try await Networking.authorizeUsingSIWA(identityToken: identityToken,
                                                                    email: credentials.email,
                                                                    firstName: credentials.fullName?.givenName,
                                                                    lastName: credentials.fullName?.familyName)
                        let userResponse = try await Networking.getUser()
                        print(userResponse.user.firstName ?? ":P")
                    }
                case .failure(let error):
                    print("Auth Failed" + error.localizedDescription)
                }
            }
            .frame(height: 50)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
