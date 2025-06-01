//
//  Target.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

import ProjectDescription

public extension Target {
    static func target(_ module: Module) -> Target {
        return .target(
            name: module.name,
            destinations: ProjectInfo.destinations,
            product: module.product,
            bundleId: module.bundleID,
            infoPlist: module.infoPlist,
            sources: module.sources,
            resources: module.resources,
            dependencies: module.dependencies
        )
    }
}

private extension Module {
    var product: Product {
        switch self {
        case .app: .app
        case .designSystem: .staticFramework
        default: .staticLibrary
        }
    }
    
    var infoPlist: InfoPlist? {
        switch self {
        case .app: .file(path: "Support/info.plist")
        default: nil
        }
    }
    
    var sources: SourceFilesList {
        ["Sources/**"]
    }
    
    var resources: ResourceFileElements? {
        switch self {
        case .designSystem: ["Resources/**"]
        default: nil
        }
    }
}
