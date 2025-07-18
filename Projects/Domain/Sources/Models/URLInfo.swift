//
//  URLInfo.swift
//  Domain
//
//  Created by 이정원 on 7/18/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct URLInfo: Equatable, Hashable {
    public let urlString: String
    public let platform: Platform
    
    public init(
        urlString: String,
        platform: Platform
    ) {
        self.urlString = urlString
        self.platform = platform
    }
}

public enum Platform {
    case homepage
    case instagram
    
    public init(value: String?) {
        switch value {
        case "HOMEPAGE": self = .homepage
        case "INSTAGRAM": self = .instagram
        default: self = .homepage
        }
    }
}
