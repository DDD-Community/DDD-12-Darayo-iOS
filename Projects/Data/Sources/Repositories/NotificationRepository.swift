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
}
