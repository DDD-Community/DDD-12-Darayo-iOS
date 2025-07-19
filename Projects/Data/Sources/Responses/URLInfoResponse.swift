//
//  URLInfoResponse.swift
//  Data
//
//  Created by 이정원 on 7/18/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain

struct URLInfoResponse: Decodable {
    let url: String?
    let type: String?
}

extension URLInfoResponse {
    var toDomain: URLInfo? {
        guard let url, let type else { return nil }
        
        return .init(
            urlString: url,
            platform: .init(value: type)
        )
    }
}
