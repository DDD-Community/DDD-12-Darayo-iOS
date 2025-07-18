//
//  URLRequest+.swift
//  Util
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension URLRequest {
    var curlString: String {
        var message = ""
        
        if let urlString = url?.absoluteString {
            message += "curl '\(urlString)'"
        }
        
        if let httpMethod {
            message += " \\\n-X \(httpMethod)"
        }
        
        if let allHTTPHeaderFields {
            allHTTPHeaderFields.forEach { (key, value) in
                message += " \\\n-H '\(key): \(value)'"
            }
        }
        
        if let body = httpBody?.jsonString {
            message += " \\\n-d '\(body)'"
        }
        
        return message
    }
}
