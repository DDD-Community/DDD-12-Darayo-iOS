//
//  Endpoint.swift
//  Data
//
//  Created by 이정원 on 6/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Util
import Domain

public protocol Endpoint {
    associatedtype Response
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: Encodable? { get }
    var body: Encodable? { get }
    var withToken: Bool { get }
}

public extension Endpoint {
    var baseURL: String {
        Constant.URL.base
    }
    
    var headers: [String: String] {
        var headers = [
            "Content-Type": "application/json",
        ]
        
        if withToken, let token = TokenStorage.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    var queryItems: [URLQueryItem]? {
        guard let queryParameters,
              let data = try? JSONEncoder().encode(queryParameters),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let dictionary = jsonObject as? [String: String] else {
            return nil
        }
        
        return dictionary.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
    
    var httpBody: Data? {
        get throws {
            guard let body else { return nil }
            return try JSONEncoder().encode(body)
        }
    }
    
    var urlRequest: URLRequest {
        get throws {
            guard var url = URL(string: baseURL) else {
                throw NetworkError(type: .invalidURL, path: path)
            }
            
            url.append(path: path)
            if let queryItems { url.append(queryItems: queryItems) }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue.uppercased()
            urlRequest.allHTTPHeaderFields = headers
            
            do {
                urlRequest.httpBody = try httpBody
            } catch let error as EncodingError {
                let message = error.localizedDescription
                throw NetworkError(type: .bodyEncoding, path: path, message: message)
            }
            
            return urlRequest
        }
    }
    
    var urlString: String? {
        URL(string: baseURL)?.appending(path: path).absoluteString
    }
}

public enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}
