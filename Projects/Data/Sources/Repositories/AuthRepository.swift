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
    
    public var isSignedIn: Bool {
        TokenStorage.accessToken != nil
    }
    
    public func signIn() async throws {
        let endpoint = AuthEnpoint.signIn(DeviceIDProvider.deviceID)
        let data = try await networkService.request(endpoint: endpoint)
        let accessToken = data?.token
        TokenStorage.accessToken = accessToken
    }
}
