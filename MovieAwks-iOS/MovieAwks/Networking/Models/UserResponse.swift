//
//  UserResponse.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation

struct UserResponse: Codable {
    let accessToken: String?
    let user: User
}
