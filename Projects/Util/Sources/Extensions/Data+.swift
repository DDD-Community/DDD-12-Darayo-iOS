//
//  Data+.swift
//  Util
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension Data {
    var toString: String? {
        String(data: self, encoding: .utf8)
    }
    
    var jsonString: String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self)
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    func decode<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
