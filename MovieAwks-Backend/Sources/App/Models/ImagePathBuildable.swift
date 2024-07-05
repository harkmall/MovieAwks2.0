//
//  File.swift
//  
//
//  Created by Mark Hall on 2024-07-05.
//

import Foundation

protocol ImagePathBuildable {
    var posterPath: String? { get set }
    var backdropPath: String? { get set }
}
extension ImagePathBuildable {
    //last one should be "original", so get the one before "original"
    mutating func buildImageUrls(with configuration: ImagesConfiguration) {
        buildBackdropUrl(with: configuration)
        buildPosterPath(with: configuration)
    }
    
    private mutating func buildBackdropUrl(with configuration: ImagesConfiguration) {
        let backdropSizeIndex = (configuration.backdropSizes?.count ?? 2) - 2
        let backdropSize = configuration.backdropSizes?[backdropSizeIndex] ?? ""
        
        backdropPath = (configuration.secureBaseUrl ?? "") + (backdropSize) + (backdropPath ?? "")
    }
    
    private mutating func buildPosterPath(with configuration: ImagesConfiguration) {
        let posterSizeIndex = (configuration.posterSizes?.count ?? 2) - 2
        let posterSize = configuration.posterSizes?[posterSizeIndex] ?? ""
        
        posterPath = (configuration.secureBaseUrl ?? "") + (posterSize) + (posterPath ?? "")
    }
    
}
