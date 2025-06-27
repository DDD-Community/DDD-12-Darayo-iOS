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
            options: module.options,
            settings: .settings(configurations: .default),
            targets: module.targets,
            schemes: module.schemes,
            resourceSynthesizers: module.resourceSynthesizers
        )
    }
}

private extension Module {
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
    
    var options: Project.Options {
        switch self {
        case .app: .options(automaticSchemesOptions: .disabled)
        default: .options()
        }
    }
}
