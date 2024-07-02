//
//  ConfigurationResponse.swift
//
//
//  Created by Mark Hall on 2024-07-02.
//

import Foundation
import Vapor
import Fluent

final class ConfigurationResponse: Content {
    let images: ImagesConfiguration
}
