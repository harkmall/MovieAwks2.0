//
//  SIWAAuthReqeustBody.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation

struct SIWAAuthRequestBody: Encodable {
    let firstName: String?
    let lastName: String?
    let appleIdentityToken: String
}
