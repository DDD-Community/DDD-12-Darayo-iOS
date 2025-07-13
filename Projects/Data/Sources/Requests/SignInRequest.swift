//
//  SignInRequest.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

struct SignInRequest: Encodable {
    let deviceId: String
    
    init(deviceID: String) {
        self.deviceId = deviceID
    }
}
