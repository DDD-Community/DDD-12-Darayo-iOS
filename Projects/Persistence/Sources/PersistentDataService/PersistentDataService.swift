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

    public func fetchAll<T: PersistentModel>() throws -> [T] {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<T>(predicate: nil)
        return try context.fetch(descriptor)
    }
    
    public func fetch<T: PersistentModel>(predicate: Predicate<T>) throws -> [T] {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try context.fetch(descriptor)
    }

    public func insert<T: PersistentModel>(_ data: T) throws {
        let context = ModelContext(container)
        context.insert(data)
        try context.save()
    }

    public func delete<T: PersistentModel>(predicate: Predicate<T>) throws {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        let data = try context.fetch(descriptor).first
        if let data { context.delete(data) }
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
