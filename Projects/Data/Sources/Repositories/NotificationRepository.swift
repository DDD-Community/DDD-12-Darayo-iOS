//
//  NotificationRepository.swift
//  Data
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain
import Dependencies

public struct NotificationRepository: NotificationRepositoryProtocol {
    @Dependency(\.networkService) private var networkService
    public init() {}
    
    public func registerPushToken(token: String?) async throws {
        let endpoint = NotificationEndpoint.registerPushToken(token: token)
        _ = try await networkService.request(endpoint: endpoint)
    }
    
    public func fetchSubscribedFestivals() async throws -> [Festival] {
        let endpoint = NotificationEndpoint.fetchSubscribedFestivals
        let result = try await networkService.request(endpoint: endpoint)
        return result?.compactMap { $0.toDomain } ?? []
    }
    
    public func fetchSubscriptionInfo(festivalID: String) async throws -> Bool {
        let endpoint = NotificationEndpoint.fetchSubsrciptionInfo(festivalID: festivalID)
        let result = try await networkService.request(endpoint: endpoint)
        return result == true
    }
    
    public func subscribe(festivalID: String) async throws {
        let endpoint = NotificationEndpoint.subscribe(festivalID: festivalID)
        _ = try await networkService.request(endpoint: endpoint)
    }
    
    public func unsubscribe(festivalID: String) async throws {
        let endpoint = NotificationEndpoint.unsubscribe(festivalID: festivalID)
        _ = try await networkService.request(endpoint: endpoint)
    }
}
