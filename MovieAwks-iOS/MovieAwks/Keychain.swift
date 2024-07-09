//
//  Keychain.swift
//  MovieAwks
//
//  Created by Mark Hall on 2024-07-08.
//

import Foundation
import KeychainSwift

protocol Keychain {
    func get(_ key: String) -> String?
    @discardableResult func set(_ value: String,
                                forKey key: String,
                                withAccess access: KeychainSwiftAccessOptions?) -> Bool
    @discardableResult func delete(_ key: String) -> Bool
}

extension KeychainSwift: Keychain { }

struct Mock_Keychain: Keychain {
    func get(_ key: String) -> String? {
        switch key {
        case "ACCESS_TOKEN":
            return "mock_access_token"
        default:
            return nil
        }
    }
    
    @discardableResult
    func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions?) -> Bool {
        return true
    }
    
    @discardableResult
    func delete(_ key: String) -> Bool {
        return true
    }   
}
