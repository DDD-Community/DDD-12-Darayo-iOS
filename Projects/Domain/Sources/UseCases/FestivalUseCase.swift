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
    
    public func fetchLikedFestivals() async throws -> [LikedFestival] {
        return try await festivalRepository.fetchLikedFestivals()
    }
    
    public func addLikedFestival(id: Int) async throws {
        let likedFestival = LikedFestival(id: id, creationDate: .now)
        return try await festivalRepository.addLikedFestival(festival: likedFestival)
    }
    
    public func deleteLikedFestival(id: Int) async throws {
        return try await festivalRepository.deleteLikedFestival(id: id)
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
