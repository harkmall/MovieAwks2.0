//
//  TrendingResponse.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-27.
//

import Foundation

struct TrendingResponse: Codable {
    let page: Int?
    let results: [TrendingObject]
    let totalPages: Int?
    let totalResults: Int?
}
