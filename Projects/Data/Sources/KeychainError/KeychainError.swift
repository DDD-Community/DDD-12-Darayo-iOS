//
//  KeychainError.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct KeychainError: Error {
    public let type: ErrorType
    public let code: Int?
    
    public init(type: ErrorType, code: Int32? = nil) {
        self.type = type
        self.code = switch code {
        case .some(let code): Int(code)
        case .none: nil
        }
    }
}

extension KeychainError {
    public enum ErrorType {
        case save
        case delete
    }
}
