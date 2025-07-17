//
//  DI.swift
//  Darayo
//
//  Created by 이정원 on 6/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies
import Domain
import Data
import Network
import Keychain

extension NetworkServiceKey: @retroactive DependencyKey {
    public static let liveValue: NetworkServiceProtocol = NetworkService()
}

extension KeychainServiceKey: @retroactive DependencyKey {
    public static let liveValue: KeychainServiceProtocol = KeychainService()
}

extension AuthRepositoryKey: @retroactive DependencyKey {
    public static let liveValue: AuthRepositoryProtocol = AuthRepository()
}

extension FestivalRepositoryKey: @retroactive DependencyKey {
    public static let liveValue: FestivalRepositoryProtocol = FestivalRepository()
}
