//
//  URLInfo.swift
//  Domain
//
//  Created by 이정원 on 7/18/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct URLInfo: Equatable, Hashable {
    public let urlString: String
    public let type: URLType?
    
    public init(
        urlString: String,
        type: URLType?
    ) {
        self.urlString = urlString
        self.type = type
    }
}

public enum URLType {
    case homepage
    case instagram
    
    public init?(value: String?) {
        switch value {
        case "HOMEPAGE": self = .homepage
        case "INSTAGRAM": self = .instagram
        default: return nil
        }
    }
}
