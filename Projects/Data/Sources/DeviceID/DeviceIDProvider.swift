//
//  DeviceIDProvider.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Dependencies
import Util

struct DeviceIDProvider {
    @Dependency(\.keychainService) private var keychainService
    private enum Key { case deviceID }
    private static let key: String = String(describing: Key.deviceID)
    private static let shared = DeviceIDProvider()
    private init() {}
    
    static var deviceID: String {
        let data = shared.keychainService.read(forKey: key)
        
        if let data {
            return data.toString ?? ""
        } else {
            let deviceID = UUID().uuidString
            if let data = deviceID.data(using: .utf8) {
                try? shared.keychainService.save(data, forKey: key)
            }
            return deviceID
        }
    }
}
