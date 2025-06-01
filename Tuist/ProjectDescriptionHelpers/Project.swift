//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

import ProjectDescription

public extension Project {
    init(module: Module) {
        self = Project(
            name: module.name,
            organizationName: ProjectInfo.organizationName,
            settings: .settings(configurations: .default),
            targets: [.target(module)],
            schemes: module.schemes,
            resourceSynthesizers: module.resourceSynthesizers
        )
    }
}

private extension Module {
    var schemes: [Scheme] {
        switch self {
        case .app:
            Environment.allCases.map { environment in
                Scheme.scheme(name: name, environment: environment)
            }
        default: []
        }
    }
    
    var resourceSynthesizers: [ResourceSynthesizer] {
        switch self {
        case .designSystem: [.assets()]
        default: []
        }
    }
}
