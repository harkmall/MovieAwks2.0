//
//  User.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation

struct User: Codable {
  let id: UUID
  let email: String
  let firstName: String?
  let lastName: String?
}
