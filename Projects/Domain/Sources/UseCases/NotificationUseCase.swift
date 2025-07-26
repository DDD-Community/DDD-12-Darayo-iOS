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
    
    public func fetchNotificationState(id: String) async throws -> Bool {
        return try await notificationRepository.fetchNotificationState(id: id)
    }
    
    public func updateNotification(id: Int, isEnabled: Bool) async throws {
        switch isEnabled {
        case true: try await notificationRepository.subscribe(id: String(id))
        case false: try await notificationRepository.unsubscribe(id: String(id))
        }
    }
    
    public func fetchNotificationState() async throws -> Bool {
        return try await notificationRepository.fetchNotificationState()
    }
    
    public func updateNotification(isEnabled: Bool) async throws {
        try await notificationRepository.updateNotification(isEnabled: isEnabled)
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
