//
//  APIEndpoint.swift
//  Data
//
//  Created by 이정원 on 7/13/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

struct APIEndpoint<R>: Endpoint {
    typealias Response = R
    let path: String
    let method: HTTPMethod
    let queryParameters: (any Encodable)?
    let body: (any Encodable)?
    let withToken: Bool
    
    init(
        path: String,
        method: HTTPMethod,
        queryParameters: Encodable? = nil,
        body: Encodable? = nil,
        withToken: Bool = true
    ) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.body = body
        self.withToken = withToken
    }
}
