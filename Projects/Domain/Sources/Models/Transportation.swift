//
//  Transportation.swift
//  Domain
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct Transportation {
    public let type: TransportationType
    public let description: String
    
    public init(
        type: TransportationType,
        description: String
    ) {
        self.type = type
        self.description = description
    }
}

public enum TransportationType {
    case subway
    case bus
}
