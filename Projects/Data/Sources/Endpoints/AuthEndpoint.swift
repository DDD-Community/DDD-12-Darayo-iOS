//
//  AuthEndpoint.swift
//  Data
//
//  Created by 이정원 on 7/13/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

enum AuthEndpoint: Endpoint {
    case signIn(String)
    
    var path: String {
        switch self {
        case .signIn: "v1/users/login"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .signIn: .post
        }
    }
    
    var queryParameters: Encodable? { nil }
    
    var body: Encodable? {
        switch self {
        case .signIn(let deviceID):
            return SignInRequest(deviceID: deviceID)
        }
    }
    
    var withToken: Bool {
        switch self {
        case .signIn: false
        }
    }
}
