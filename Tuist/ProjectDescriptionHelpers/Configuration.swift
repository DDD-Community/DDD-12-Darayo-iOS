//
//  Configuration.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

import ProjectDescription

extension ConfigurationName {
    static let dev = ConfigurationName.configuration(Environment.dev.name)
    static let stage = ConfigurationName.configuration(Environment.stage.name)
    static let prod = ConfigurationName.configuration(Environment.prod.name)
}

public extension Array where Element == Configuration {
    static let `default`: [Configuration] = [
        .debug(name: .dev, xcconfig: .path(.dev)),
        .debug(name: .stage, xcconfig: .path(.stage)),
        .debug(name: .prod, xcconfig: .path(.prod)),
        .release(name: .release, xcconfig: .path(.release))
    ]
}

private extension ProjectDescription.Path {
    static func path(_ configuration: ConfigurationName) -> Self {
        return .relativeToRoot("Configs/\(configuration.rawValue).xcconfig")
    }
}
