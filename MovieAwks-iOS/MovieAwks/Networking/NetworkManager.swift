//
//  Networking.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-06-24.
//

import Foundation
import Alamofire
import KeychainSwift

class NetworkingManager {
 
    let keychain: Keychain
    let environment: NetworkingManager.Environment
    
    private let jsonDecoder: JSONDecoder
    
    static var current: NetworkingManager = {
        return .init()
    }()
    
    init(keychain: Keychain = KeychainSwift(),
         environment: NetworkingManager.Environment = .current) {
        self.keychain = keychain
        self.environment = environment
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .secondsSince1970
    }
    
    func request<ParameterType, DecodingType>(needsAuth: Bool = true,
                                              endpoint: String,
                                              method: HTTPMethod = .get,
                                              parameters: ParameterType? = nil as String?, //weird, have to do this so the compiler can figure out what the default nil is...
                                              headers: HTTPHeaders? = nil,
                                              decodingType: DecodingType.Type) async throws -> DecodingType where DecodingType: Decodable, ParameterType: Encodable {
        
        var headers = headers
        if needsAuth {
            guard let accessToken = await keychain.get(MovieAwksApp.accessTokenKey) else { throw NetworkingManager.Error.missingAccessToken }
            headers = headers ?? HTTPHeaders()
            headers?.add(.authorization(bearerToken: accessToken))
        }
        
        return try await AF
            .request(environment.baseURL + endpoint,
                     method: method,
                     parameters: parameters,
                     headers: headers)
            .serializingDecodable(decodingType,
                                  decoder: self.jsonDecoder)
            .value
    }
}

extension NetworkingManager {
    enum Environment {
        case development
        case production
        
        static var current: Environment {
            return .development //make this dependent on something like a build flag
        }
        
        var baseURL: String {
            switch self {
            case .development:
                return "https://582c-2607-fea8-28a1-b700-5df0-246f-9739-68d3.ngrok-free.app"
            case .production:
                return "" //fix this at some point
            }
        }
    }
}

extension NetworkingManager {
    enum Error: LocalizedError {
        case missingAccessToken
    }
}
