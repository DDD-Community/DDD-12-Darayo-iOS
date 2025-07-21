//
//  PersistentDataService.swift
//  Persistence
//
//  Created by 이정원 on 7/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import SwiftData
import Data

public struct PersistentDataService: PersistentDataServiceProtocol {
    private let container = ModelContainer.festibee
    public init() {}

    @MainActor public func fetchAll<T: PersistentModel>() throws -> [T] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<T>(predicate: nil)
        return try context.fetch(descriptor)
    }
    
    @MainActor public func fetch<T: PersistentModel>(predicate: Predicate<T>) async throws -> [T] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try context.fetch(descriptor)
    }

    @MainActor public func insert<T: PersistentModel>(_ data: T) throws {
        let context = container.mainContext
        context.insert(data)
        try context.save()
    }

    @MainActor public func delete<T: PersistentModel>(_ data: T) throws {
        let context = container.mainContext
        context.delete(data)
        try context.save()
    }
}

public extension ModelContainer {
    static let festibee: ModelContainer = {
        let schema = Schema([LikedFestival.self])

        do {
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Unable to create Model Container")
        }
    }()
}
