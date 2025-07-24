//
//  NotificationUseCase.swift
//  Domain
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies

public struct NotificationUseCase {
    @Dependency(\.notificationRepository) private var notificationRepository
    
    public func registerPushToken(token: String?) async throws {
        try await notificationRepository.registerPushToken(token: token)
    }
    
    public func fetchSubscribedFestivals() async throws -> [Festival] {
        try await notificationRepository.fetchSubscribedFestivals()
    }
    
    public func fetchSubscriptionInfo(festivalID: String) async throws -> Bool {
        return try await notificationRepository.fetchSubscriptionInfo(festivalID: festivalID)
    }
    
    public func subscribe(festivalID: String) async throws {
        try await notificationRepository.subscribe(festivalID: festivalID)
    }
    
    public func unsubscribe(festivalID: String) async throws {
        try await notificationRepository.unsubscribe(festivalID: festivalID)
    }
    
    public func fetchNotificationState() async throws -> Bool {
        return try await notificationRepository.fetchNotificationState()
    }
    
    public func updateNotificationState(isEnabled: Bool) async throws {
        try await notificationRepository.updateNotificationState(isEnabled: isEnabled)
    }
}

private enum NotificationUseCaseKey: DependencyKey {
    public static let liveValue = NotificationUseCase()
}

public extension DependencyValues {
    var notificationUseCase: NotificationUseCase {
        get { self[NotificationUseCaseKey.self] }
        set { self[NotificationUseCaseKey.self] = newValue }
    }
}
