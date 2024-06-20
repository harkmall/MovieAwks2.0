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
                request.requestedScopes = [.fullName]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Auth successful")
                    guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential,
                            let identityToken = credentials.identityToken,
                          let identityTokenString = String(data: identityToken, encoding: .utf8) else { return }
                    print(identityTokenString)
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
