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
    
    public var isSignedIn: Bool {
        let isSignedIn = authRepository.isSignedIn
        return isSignedIn
    }
    
    public func signIn() async throws {
        try await authRepository.signIn()
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
