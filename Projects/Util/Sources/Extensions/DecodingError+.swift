//
//  DecodingError+.swift
//  Util
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension DecodingError {
    var message: String {
        var message = switch self {
        case .keyNotFound(let key, let value):
            "Key Not Found, Key: \(key), Value: \(value)"
        case .valueNotFound(let key, let value):
            "Value Not Found, Key: \(key), Value: \(value)"
        case .typeMismatch(let key, let value):
            "Type Mismatch, Key: \(key), Value: \(value)"
        case .dataCorrupted(let context):
            "Data Corrupted, Context: \(context)"
        @unknown default: ""
        }
        
        message += "\n\(localizedDescription)"
        return message
    }
}
