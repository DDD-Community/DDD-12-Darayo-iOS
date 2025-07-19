//
//  NetworkError.swift
//  Data
//
//  Created by 이정원 on 6/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct NetworkError: Error {
    public let type: ErrorType
    public let path: String?
    public let code: Int?
    public let message: String?
    
    public init(
        type: ErrorType,
        path: String? = nil,
        code: Int? = nil,
        message: String? = nil
    ) {
        self.type = type
        self.path = path
        self.code = code
        self.message = message
    }
}

extension NetworkError {
    public enum ErrorType {
        case invalidURL
        case bodyEncoding
        case disconnected
        case noResponse
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case timeout
        case client
        case server
        case others
        case responseDecoding
        case unknown
        
        public init(statusCode: Int) {
            self = switch statusCode {
            case 400: .badRequest
            case 401: .unauthorized
            case 403: .forbidden
            case 404: .notFound
            case 400...499: .client
            case 500...599: .server
            default: .others
            }
        }
    }
}
