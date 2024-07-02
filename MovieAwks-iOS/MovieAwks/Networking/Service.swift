//
//  Service.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-25.
//

import Foundation
import Alamofire

protocol Service {
    var environment: Networking.Environment { get set }
}
