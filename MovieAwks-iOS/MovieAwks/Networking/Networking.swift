//
//  Networking.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation
import Alamofire

struct Networking {
    enum Environment {
        case development
        case production
        
        static var current: Environment {
            return .development //make this dependent on something like a build flag
        }
        
        var baseURL: String {
            switch self {
            case .development:
                return "https://cba3-66-203-169-98.ngrok-free.app"
            case .production:
                return "" //fix this at some point
            }
        }
    }
}
