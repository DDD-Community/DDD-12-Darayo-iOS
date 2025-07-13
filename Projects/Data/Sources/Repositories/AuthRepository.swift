//
//  AuthRepository.swift
//  Data
//
//  Created by 이정원 on 7/13/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain
import Dependencies

public struct AuthRepository: AuthRepositoryProtocol {
    @Dependency(\.networkService) private var networkService
    public init() {}
    
    public func signIn(deviceID: String) async throws -> String? {
        let endpoint = AuthEndpoint.signIn(deviceID)
        let response: ResponseWrapper<SignInResponse> = try await networkService.request(endpoint: endpoint)
        return response.result?.token
    }
}
