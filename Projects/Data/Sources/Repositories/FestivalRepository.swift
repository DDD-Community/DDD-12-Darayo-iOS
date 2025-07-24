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
    
    public func fetchLikedFestivals() throws -> [Domain.LikedFestival] {
        let likedFestivals: [LikedFestival] = try persistentDataService.fetchAll()
        return likedFestivals.map { $0.toDomain }
        
    }
    
    public func addLikedFestival(festival: Domain.LikedFestival) throws {
        let likedFestival = LikedFestival(id: festival.id, creationDate: festival.creationDate)
        try persistentDataService.insert(likedFestival)
    }
    
    public func deleteLikedFestival(id: Int) throws {
        let predicate = #Predicate<LikedFestival> { $0.id == id }
        try persistentDataService.delete(predicate: predicate)
    }
}
