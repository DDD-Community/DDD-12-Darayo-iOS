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
    func signIn(deviceID: String) async throws -> String?
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
