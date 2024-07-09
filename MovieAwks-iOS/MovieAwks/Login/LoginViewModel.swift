//
//  LoginViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import AuthenticationServices

extension LoginView {
    @MainActor
    class ViewModel: ObservableObject {
        enum State {
            case idle
            case loading
            case error(error: Error)
        }
        
        let userRepo: UserRepository
        
        @Published private(set) var state: State = .idle
        
        init(userRepo: UserRepository) {
            self.userRepo = userRepo
        }
        
        func handle(appleAuthResult: Result<ASAuthorization, Error>) async {
            state = .loading
            switch appleAuthResult {
            case .success(let authResults):
                await saveUserToDB(with: authResults)
            case .failure(let error):
                state = .error(error: error)
            }
            
        }
        
        private func saveUserToDB(with authResults: ASAuthorization) async {
            guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential,
                  let identityToken = credentials.identityToken else {
                state = .error(error: APIError.identityTokenMissing)
                return
            }
            
            do {
                try await userRepo.authorizeUsingSIWA(identityToken: identityToken,
                                                      firstName: credentials.fullName?.givenName,
                                                      lastName: credentials.fullName?.familyName)
                try await userRepo.getUser()
            } catch {
                self.state = .error(error: error)
            }
        }
    }
}
