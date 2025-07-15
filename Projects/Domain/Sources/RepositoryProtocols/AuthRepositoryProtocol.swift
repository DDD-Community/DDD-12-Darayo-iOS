//
//  AuthRepositoryProtocol.swift
//  Domain
//
//  Created by 이정원 on 7/13/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies
import Util

public protocol AuthRepositoryProtocol {
    var isSignedIn: Bool { get }
    func signIn() async throws
}

public enum AuthRepositoryKey: TestDependencyKey {
    public static var testValue: AuthRepositoryProtocol {
        unimplemented(AuthRepositoryProtocol.self)
    }
}

extension DependencyValues {
    var authRepository: AuthRepositoryProtocol {
        get { self[AuthRepositoryKey.self] }
        set { self[AuthRepositoryKey.self] = newValue }
    }
}
