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
    func request(endpoint: Endpoint) async throws
    func request<Response: Decodable>(endpoint: Endpoint) async throws -> Response
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
