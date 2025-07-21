//
//  PersistentDataServiceProtocol.swift
//  Data
//
//  Created by 이정원 on 7/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import SwiftData
import Dependencies
import Util

public protocol PersistentDataServiceProtocol {
    @MainActor func fetchAll<T: PersistentModel>() throws -> [T]
    @MainActor func fetch<T: PersistentModel>(predicate: Predicate<T>) async throws -> [T]
    @MainActor func insert<T: PersistentModel>(_ data: T) throws
    @MainActor func delete<T: PersistentModel>(_ data: T) throws
}

public enum PersistentDataServiceKey: TestDependencyKey {
    public static var testValue: PersistentDataServiceProtocol {
        unimplemented(PersistentDataServiceProtocol.self)
    }
}

extension DependencyValues {
    var persistentDataService: PersistentDataServiceProtocol {
        get { self[PersistentDataServiceKey.self] }
        set { self[PersistentDataServiceKey.self] = newValue }
    }
}
