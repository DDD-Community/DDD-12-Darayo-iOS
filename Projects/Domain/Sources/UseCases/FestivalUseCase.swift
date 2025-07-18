//
//  FestivalUseCase.swift
//  Domain
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies

public struct FestivalUseCase {
    @Dependency(\.festivalRepository) private var festivalRepository
    
    public func fetchFestivals() async throws -> [Festival] {
        return try await festivalRepository.fetchFestivals()
    }
}

private enum FestivalUseCaseKey: DependencyKey {
    public static let liveValue = FestivalUseCase()
}

public extension DependencyValues {
    var festivalUseCase: FestivalUseCase {
        get { self[FestivalUseCaseKey.self] }
        set { self[FestivalUseCaseKey.self] = newValue }
    }
}
