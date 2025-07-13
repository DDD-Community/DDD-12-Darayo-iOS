//
//  AuthUseCase.swift
//  Domain
//
//  Created by 이정원 on 7/13/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies

public struct AuthUseCase {
    @Dependency(\.authRepository) private var authRepository
    
    public func signIn() async throws {
        // TODO: fetch device ID
        let accessToken = try await authRepository.signIn(deviceID: "")
        // TODO: save access token
        return
    }
}

private enum AuthUseCaseKey: DependencyKey {
    public static let liveValue = AuthUseCase()
}

public extension DependencyValues {
    var authUseCase: AuthUseCase {
        get { self[AuthUseCaseKey.self] }
        set { self[AuthUseCaseKey.self] = newValue }
    }
}
