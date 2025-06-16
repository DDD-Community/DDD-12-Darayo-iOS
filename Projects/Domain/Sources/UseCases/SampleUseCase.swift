//
//  SampleUseCase.swift
//  Domain
//
//  Created by 이정원 on 6/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies

public struct SampleUseCase {
    @Dependency(\.sampleRepository) private var sampleRepository
    
    public func fetchCoffeeList() async throws -> [Coffee] {
        return try await sampleRepository.fetchCoffeeList()
    }
}

private enum SampleUseCaseKey: DependencyKey {
    public static let liveValue = SampleUseCase()
}

public extension DependencyValues {
    var sampleUseCase: SampleUseCase {
        get { self[SampleUseCaseKey.self] }
        set { self[SampleUseCaseKey.self] = newValue }
    }
}
