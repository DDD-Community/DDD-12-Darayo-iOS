//
//  NotificationRepositoryProtocol.swift
//  Domain
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies
import Util

public protocol NotificationRepositoryProtocol {
    func registerPushToken(token: String?) async throws
}

public enum NotificationRepositoryKey: TestDependencyKey {
    public static var testValue: NotificationRepositoryProtocol {
        unimplemented(NotificationRepositoryProtocol.self)
    }
}

extension DependencyValues {
    var notificationRepository: NotificationRepositoryProtocol {
        get { self[NotificationRepositoryKey.self] }
        set { self[NotificationRepositoryKey.self] = newValue }
    }
}
