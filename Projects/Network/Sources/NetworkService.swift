//
//  NetworkService.swift
//  Network
//
//  Created by 이정원 on 6/7/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Data

public struct NetworkService: NetworkServiceProtocol {
    public init() {}
    
    public func request(endpoint: Endpoint) async throws {
        try await performRequest(endpoint: endpoint)
    }
    
    public func request<Response: Decodable>(endpoint: Endpoint) async throws -> Response {
        let (data, statusCode) = try await performRequest(endpoint: endpoint)
        do {
            return try data.decode()
        } catch let error as DecodingError {
            throw NetworkError(
                type: .responseDecoding,
                path: endpoint.path,
                code: statusCode,
                message: error.message
            )
        }
    }
}

private extension NetworkService {
    var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return .init(configuration: configuration)
    }
    
    @discardableResult
    func performRequest(endpoint: Endpoint) async throws -> (Data, Int) {
        do {
            let (data, urlResponse) = try await urlSession.data(for: endpoint.urlRequest)
            let httpURLResponse = urlResponse as? HTTPURLResponse
            guard let httpURLResponse else { throw NetworkError(type: .noResponse) }
            
            let statusCode = httpURLResponse.statusCode
            switch statusCode {
            case 200...299: return (data, statusCode)
            default: throw NetworkError(type: .init(statusCode: statusCode))
            }
        } catch let error as NetworkError {
            throw NetworkError(type: error.type, path: endpoint.path)
        } catch let error {
            throw NetworkError(
                type: .others,
                path: endpoint.path,
                message: error.localizedDescription
            )
        }
    }
}

private extension Data {
    func decode<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

private extension DecodingError {
    var message: String {
        var message = ""
        switch self {
        case .dataCorrupted(let context):
            message = "Data corrupted: \(context.debugDescription)"
            message += "CodingPath: \(context.codingPath)"
        case .keyNotFound(let key, let context):
            message = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
            message += "CodingPath: \(context.codingPath)"
        case .typeMismatch(let type, let context):
            message = "Type '\(type)' mismatch: \(context.debugDescription)"
            message += "CodingPath: \(context.codingPath)"
        case .valueNotFound(let type, let context):
            message = "Value '\(type)' not found: \(context.debugDescription)"
            message += "CodingPath: \(context.codingPath)"
        @unknown default:
            message = "Unknown DecodingError: \(self)"
        }
        return message
    }
}
