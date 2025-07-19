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
