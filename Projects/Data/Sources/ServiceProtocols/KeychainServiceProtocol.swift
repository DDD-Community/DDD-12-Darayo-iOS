//
//  KeychainServiceProtocol.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Dependencies
import Util

public protocol KeychainServiceProtocol {
    func read(forKey key: String) -> Data?
    func save(_ data: Data, forKey key: String) throws
    func delete(forKey key: String) throws
}

public enum KeychainServiceKey: TestDependencyKey {
    public static var testValue: KeychainServiceProtocol {
        unimplemented(KeychainServiceProtocol.self)
    }
}

extension DependencyValues {
    var keychainService: KeychainServiceProtocol {
        get { self[KeychainServiceKey.self] }
        set { self[KeychainServiceKey.self] = newValue }
    }
}

