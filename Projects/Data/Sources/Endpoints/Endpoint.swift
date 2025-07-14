//
//  Endpoint.swift
//  Data
//
//  Created by 이정원 on 6/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Util

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: Encodable? { get }
    var body: Encodable? { get }
    var withToken: Bool { get }
}

public enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

extension Endpoint {
    var baseURL: String {
        Constant.URL.base
    }
    
    var headers: [String: String] {
        var headers = [
            "Content-Type": "application/json",
        ]
        
        if withToken, let token = TokenStorage.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    var withToken: Bool { true }
}
