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
    
    public func fetchLikedFestivals() throws -> [LikedFestival] {
        return try festivalRepository.fetchLikedFestivals()
    }
    
    public func isFavorite(_ festival: Festival) throws -> Bool {
        let ids = try Set(fetchLikedFestivals().map { $0.id })
        return ids.contains(festival.id)
    }
    
    public func addLikedFestival(id: Int) throws {
        let likedFestival = LikedFestival(id: id, creationDate: .now)
        return try festivalRepository.addLikedFestival(festival: likedFestival)
    }
    
    public func deleteLikedFestival(id: Int) throws {
        return try festivalRepository.deleteLikedFestival(id: id)
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
