//
//  SampleEndpoint.swift
//  Data
//
//  Created by 이정원 on 6/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

enum SampleEndpoint: Endpoint {
    case coffee
    var path: String { "coffee/iced" }
    var method: HTTPMethod { .get }
    var queryParameters: Encodable? { nil }
    var body: Encodable? { nil }
}
