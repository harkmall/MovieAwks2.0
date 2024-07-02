//
//  TrendingResponse.swift
//
//
//  Created by Mark Hall on 2024-06-26.
//

import Foundation
import Vapor

struct TrendingResponse: Content {
    let page: Int?
    var results: [TrendingObject]
    let totalPages: Int?
    let totalResults: Int?
}
