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
    
    public func subscribe(id: String) async throws {
        let endpoint = NotificationEndpoint.subscribe(festivalID: id)
        _ = try await networkService.request(endpoint: endpoint)
    }
    
    public func unsubscribe(id: String) async throws {
        let endpoint = NotificationEndpoint.unsubscribe(festivalID: id)
        _ = try await networkService.request(endpoint: endpoint)
    }
    
    public func fetchNotificationState() async throws -> Bool {
        let endpoint = NotificationEndpoint.fetchNotificationState
        let result = try await networkService.request(endpoint: endpoint)
        return result == true
    }
    
    public func updateNotificationState(isEnabled: Bool) async throws {
        let endpoint = NotificationEndpoint.updtateNotificationState(isEnabled: isEnabled)
        _ = try await networkService.request(endpoint: endpoint)
    }
}
