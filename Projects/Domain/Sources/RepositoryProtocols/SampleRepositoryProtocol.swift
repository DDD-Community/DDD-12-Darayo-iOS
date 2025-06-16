//
//  SampleRepositoryProtocol.swift
//  Domain
//
//  Created by 이정원 on 6/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies

public protocol SampleRepositoryProtocol {
    func fetchCoffeeList() async throws -> [Coffee]
}

private struct MockSampleRepository: SampleRepositoryProtocol {
    func fetchCoffeeList() async throws -> [Coffee] { [] }
}

public enum SampleRepositoryKey: TestDependencyKey {
    public static let testValue: SampleRepositoryProtocol = MockSampleRepository()
}

extension DependencyValues {
    var sampleRepository: SampleRepositoryProtocol {
        get { self[SampleRepositoryKey.self] }
        set { self[SampleRepositoryKey.self] = newValue }
    }
}
