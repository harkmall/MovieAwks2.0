//
//  HomeView.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userRepo: UserRepository
    
    var body: some View {
        Group {
            Spacer()
            Text("\(userRepo.user?.firstName ?? ":P") \(userRepo.user?.lastName ?? ":PP")")
            Spacer()
            Button(action: {
                userRepo.logoutUser()
            }, label: {
                Text("Logout")
            })
        }
        .onAppear(perform: {
            Task {
                try await userRepo.getUser()
            }
        })
    }
}

#Preview {
    HomeView()
        .environmentObject(UserRepository(environment: .development))
}
