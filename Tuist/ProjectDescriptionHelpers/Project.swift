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
            settings: module.settings,
            targets: module.targets,
            schemes: module.schemes,
            resourceSynthesizers: module.resourceSynthesizers
        )
    }
}

private extension Module {
    var settings: Settings {
        .settings(
            base: ["ENABLE_USER_SCRIPT_SANDBOXING": "YES"],
            configurations: .default
        )
    }
    
    var targets: [Target] {
        switch self {
        case .designSystem: [.target(self), .demo(of: self)]
        default: [.target(self)]
        }
    }
    
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
        case .designSystem:
            [
                .fonts(),
                .custom(name: "Images", parser: .assets, extensions: ["xcassets"]),
                .custom(name: "Colors", parser: .assets, extensions: ["xcassets"])
            ]
        default: []
        }
    }
}
