//
//  LoginViewModel.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import AuthenticationServices

class LoginViewModel: ObservableObject {
    var userRepo: UserRepository
    
    @Published var error: Error?
    @Published var isLoading: Bool
    
    init(userRepo: UserRepository) {
        self.userRepo = userRepo
        self.isLoading = false
    }
    
    func handle(appleAuthResult: Result<ASAuthorization, Error>) async {
        await MainActor.run {
            self.isLoading = true
        }
        switch appleAuthResult {
        case .success(let authResults):
            await saveUserToDB(with: authResults)
        case .failure(let error):
            await MainActor.run {
                self.error = error
            }
        }

    }
    
    private func saveUserToDB(with authResults: ASAuthorization) async {
        guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credentials.identityToken else {
            self.isLoading = false
            self.error = APIError.identityTokenMissing
            return
        }
        
        do {
            try await userRepo.authorizeUsingSIWA(identityToken: identityToken,
                                                  firstName: credentials.fullName?.givenName,
                                                  lastName: credentials.fullName?.familyName)
            try await userRepo.getUser()
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.error = error
            }
        }
    }
}
