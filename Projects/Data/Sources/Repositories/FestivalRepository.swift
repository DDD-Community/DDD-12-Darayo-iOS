//
//  FestivalRepository.swift
//  Data
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain
import Dependencies

public struct FestivalRepository: FestivalRepositoryProtocol {
    @Dependency(\.networkService) private var networkService
    public init() {}
    
    public func fetchFestivals() async throws -> [Festival] {
        let endpoint = FestivalEndpoint.fetchFestivals
        let result = try await networkService.request(endpoint: endpoint)
        return result?.compactMap { $0.toDomain } ?? []
    }
}
