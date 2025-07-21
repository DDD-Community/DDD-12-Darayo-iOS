//
//  FestivalRepository.swift
//  Data
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Domain
import Dependencies

public struct FestivalRepository: FestivalRepositoryProtocol {
    @Dependency(\.networkService) private var networkService
    @Dependency(\.persistentDataService) private var persistentDataService
    
    public init() {}
    
    public func fetchFestivals() async throws -> [Festival] {
        let endpoint = FestivalEndpoint.fetchFestivals
        let result = try await networkService.request(endpoint: endpoint)
        return result?.compactMap { $0.toDomain } ?? []
    }
    
    public func fetchLikedFestivals() async throws -> [Domain.LikedFestival] {
        let likedFestivals: [LikedFestival] = try await persistentDataService.fetchAll()
        return likedFestivals.map { $0.toDomain }
        
    }
    
    public func addLikedFestival(festival: Domain.LikedFestival) async throws {
        let likedFestival = LikedFestival(id: festival.id, creationDate: festival.creationDate)
        try await persistentDataService.insert(likedFestival)
    }
    
    public func deleteLikedFestival(id: Int) async throws {
        let predicate = #Predicate<LikedFestival> { $0.id == id }
        let festival = try await persistentDataService.fetch(predicate: predicate).first
        guard let festival else { return }
        try await persistentDataService.delete(festival)
    }
}
