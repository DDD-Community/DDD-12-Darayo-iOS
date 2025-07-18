//
//  NetworkServiceProtocol.swift
//  Data
//
//  Created by 이정원 on 6/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies
import Util

public protocol NetworkServiceProtocol {
    func request<R: Decodable, E: Endpoint>(endpoint: E) async throws -> E.Response? where E.Response == R
}

public enum NetworkServiceKey: TestDependencyKey {
    public static var testValue: NetworkServiceProtocol {
        unimplemented(NetworkServiceProtocol.self)
    }
}

extension DependencyValues {
    var networkService: NetworkServiceProtocol {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}
