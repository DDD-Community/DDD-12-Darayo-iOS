//
//  Environment.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

public enum Environment: CaseIterable {
    case dev, stage, prod
    
    public var name: String {
        switch self {
        case .dev: "Dev"
        case .stage: "Stage"
        case .prod: "Prod"
        }
    }
}
