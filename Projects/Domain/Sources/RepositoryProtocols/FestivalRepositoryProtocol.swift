//
//  FestivalRepositoryProtocol.swift
//  Domain
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies
import Util

public protocol FestivalRepositoryProtocol {
    func fetchFestivals() async throws -> [Festival]
}

public enum FestivalRepositoryKey: TestDependencyKey {
    public static var testValue: FestivalRepositoryProtocol {
        unimplemented(FestivalRepositoryProtocol.self)
    }
}

extension DependencyValues {
    var festivalRepository: FestivalRepositoryProtocol {
        get { self[FestivalRepositoryKey.self] }
        set { self[FestivalRepositoryKey.self] = newValue }
    }
}
