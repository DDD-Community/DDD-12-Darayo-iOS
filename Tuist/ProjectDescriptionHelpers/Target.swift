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
            deploymentTargets: ProjectInfo.deploymentTargets,
            infoPlist: module.infoPlist,
            sources: module.sources,
            resources: module.resources,
            dependencies: module.dependencies,
            settings: .settings(configurations: .default)
        )
    }
    
    static func demo(of module: Module) -> Target {
        return .target(
            name: "\(module.name)Demo",
            destinations: ProjectInfo.destinations,
            product: .app,
            bundleId: "\(module.bundleID).demo",
            deploymentTargets: ProjectInfo.deploymentTargets,
            infoPlist: .file(path: "Demo/Support/info.plist"),
            sources: module.demoSources,
            dependencies: [.target(.target(module))],
            settings: .settings(configurations: .default)
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
        default: .default
        }
    }
    
    var sources: SourceFilesList {
        ["Sources/**"]
    }
    
    var demoSources: SourceFilesList {
        ["Demo/Sources/**"]
    }
    
    var resources: ResourceFileElements? {
        switch self {
        case .app, .designSystem, .util: ["Resources/**"]
        default: nil
        }
    }
}
