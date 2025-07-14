//
//  TokenStorage.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies

struct TokenStorage {
    @Dependency(\.keychainService) private var keychainService
    private enum Key { case accessToken }
    private static let key: String = String(describing: Key.accessToken)
    private static let shared = TokenStorage()
    private init() {}
    
    static var accessToken: String? {
        get {
            let data = shared.keychainService.read(forKey: key)
            guard let data else { return nil }
            return String(data: data, encoding: .utf8)
        }
        
        set {
            if let newValue {
                guard let newData = newValue.data(using: .utf8) else { return }
                let data = shared.keychainService.read(forKey: key)
                if data != nil { try? shared.keychainService.delete(forKey: key) }
                try? shared.keychainService.save(newData, forKey: key)
            } else {
                try? shared.keychainService.delete(forKey: key)
            }
        }
    }
}
