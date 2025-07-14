//
//  KeychainService.swift
//  Keychain
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Security
import Data

public struct KeychainService: KeychainServiceProtocol {
    public init() {}
    
    public func read(forKey key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        guard status == errSecSuccess else { return nil }
        return item as? Data
    }
    
    public func save(_ data: Data, forKey key: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else {
            throw KeychainError(type: .save, code: status)
        }
    }
    
    public func delete(forKey key: String) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        guard status == errSecSuccess else {
            throw KeychainError(type: .delete, code: status)
        }
    }
}
