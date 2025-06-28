//
//  Environment.swift
//  Util
//
//  Created by 이정원 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public enum Environment {
    case dev
    case stage
    case prod
    
    init?(value: String?) {
        guard let value else { return nil }
        
        switch value {
        case "DEV": self = .dev
        case "STAGE": self = .stage
        case "PROD": self = .prod
        default: return nil
        }
    }
    
    public var name: String {
        switch self {
        case .dev: "DEV"
        case .stage: "STAGE"
        case .prod: "PROD"
        }
    }
    
    public static var current = Environment(value: Bundle.environment) ?? .prod
}
