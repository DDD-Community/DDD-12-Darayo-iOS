//
//  Endpoint.swift
//  Network
//
//  Created by 이정원 on 6/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Data

extension Endpoint {
    var urlRequest: URLRequest {
        get throws {
            guard var url = URL(string: baseURL) else {
                throw NetworkError(type: .invalidURL, path: path)
            }
            
            url = url.appending(path: path)
            if let queryParameters {
                let queryItems = queryParameters.dictionary.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                url.append(queryItems: queryItems)
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue.uppercased()
            urlRequest.allHTTPHeaderFields = headers
            
            if let body {
                do {
                    let data = try JSONEncoder().encode(body)
                    urlRequest.httpBody = data
                } catch let error as EncodingError {
                    let message = error.localizedDescription
                    let error = NetworkError(type: .bodyEncoding, path: path, message: message)
                    throw error
                }
            }
            return urlRequest
        }
    }
}

private extension Encodable {
    var dictionary: [String: String] {
        do {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: String]
            return dictionary ?? [:]
        } catch {
            return [:]
        }
    }
}
