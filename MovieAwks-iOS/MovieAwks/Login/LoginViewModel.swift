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
    
    init(userRepo: UserRepository) {
        self.userRepo = userRepo
    }
    
    func handle(appleAuthResult: Result<ASAuthorization, Error>) async {
//        switch appleAuthResult {
//        case .success(let authResults):
//            await saveUserToDB(with: authResults)
//        case .failure(let error):
//            self.error = error
//        }
        await MainActor.run {
            self.error = APIError.identityTokenMissing
        }
    }
    
    private func saveUserToDB(with authResults: ASAuthorization) async {
        guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credentials.identityToken else { return }
        
        do {
            try await userRepo.authorizeUsingSIWA(identityToken: identityToken,
                                                  firstName: credentials.fullName?.givenName,
                                                  lastName: credentials.fullName?.familyName)
            try await userRepo.getUser()
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
}
