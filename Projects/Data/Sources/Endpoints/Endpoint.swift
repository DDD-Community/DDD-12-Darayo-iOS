//
//  Endpoint.swift
//  Data
//
//  Created by 이정원 on 6/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: Encodable? { get }
    var body: Encodable? { get }
}

public enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}
