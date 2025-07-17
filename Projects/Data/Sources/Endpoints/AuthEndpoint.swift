//
//  AuthEndpoint.swift
//  Data
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

enum AuthEndpoint {
    private enum Path {
        static let signIn = "v1/users/login"
    }
    
    static func signIn(_ deviceID: String) -> APIEndpoint<SignInResponse> {
        return APIEndpoint<SignInResponse>(
            path: Path.signIn,
            method: .post,
            body: SignInRequest(deviceID: deviceID),
            withToken: false
        )
    }
}
