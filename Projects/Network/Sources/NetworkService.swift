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
    
    public func request<R: Decodable, E: Endpoint>(endpoint: E) async throws -> E.Response? where E.Response == R {
        var code: Int?
        var message: String?
        
        do {
            let urlRequest = try endpoint.urlRequest
            let (data, urlResponse) = try await urlSession.data(for: urlRequest)
            let httpURLResponse = urlResponse as? HTTPURLResponse
            guard let httpURLResponse else { throw NetworkError(type: .noResponse) }
            
            let statusCode = httpURLResponse.statusCode
            code = statusCode
            
            switch statusCode {
            case 200...299:
                let response: ResponseWrapper<R> = try data.decode()
                return response.result
            default:
                let response: ResponseWrapper<R> = try data.decode()
                message = response.error
                throw NetworkError(type: .init(statusCode: statusCode))
            }
        } catch {
            let base = networkError(error)
            let networkError = NetworkError(
                type: base.type,
                path: endpoint.urlString,
                code: code,
                message: base.message ?? message
            )
            throw networkError
        }
    }
}

private extension NetworkService {
    var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        return .init(configuration: configuration)
    }
    
    func networkError(_ error: Error) -> NetworkError {
        return switch error {
        case let urlError as URLError: networkError(urlError)
        case let decodingError as DecodingError: networkError(decodingError)
        case let networkError as NetworkError: networkError
        default: NetworkError(type: .others)
        }
    }
    
    func networkError(_ error: URLError) -> NetworkError {
        let message = error.localizedDescription
        let type: NetworkError.ErrorType = switch error.code {
        case .networkConnectionLost, .timedOut: .timeout
        default: .others
        }
        
        return NetworkError(type: type, message: message)
    }
    
    func networkError(_ error: DecodingError) -> NetworkError {
        let message = error.message
        return NetworkError(type: .responseDecoding, message: message)
    }
}
