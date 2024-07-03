//
//  ProfileView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-03.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var profileViewModel: ProfileViewModel
    
    init(profileViewModel: ProfileViewModel) {
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
    }
    
    var body: some View {
        
        Text(self.profileViewModel.name)
        Button(action: {
            profileViewModel.logoutUser()
        }, label: {
            Text("Logout")
        })
    }
}

#Preview {
    ProfileView(profileViewModel: ProfileViewModel(userRepo: UserRepository()))
}
