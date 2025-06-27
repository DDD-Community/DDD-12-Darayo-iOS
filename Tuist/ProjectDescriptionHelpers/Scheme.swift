//
//  Scheme.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

import ProjectDescription

public extension Scheme {
    static func scheme(name: String, environment: Environment) -> Scheme {
        let appName = ProjectInfo.appName
        let schemeName = switch environment {
        case .prod: appName.uppercased()
        case .dev, .stage: "\(appName)+\(environment.name)".uppercased()
        }

        return .scheme(
            name: schemeName,
            buildAction: .buildAction(targets: [.target(name)]),
            runAction: .runAction(configuration: .init(stringLiteral: environment.name)),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    }
}
