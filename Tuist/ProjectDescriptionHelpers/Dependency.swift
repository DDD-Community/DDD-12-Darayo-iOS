//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

import ProjectDescription

extension Module {
    private static let dependencyInfo: [Module: [Module]] = [
        .app: [.feature(.root), .network],
        .feature(.root): [.feature(.home), .feature(.timetable), .feature(.myPage)],
        .feature(.home): [.feature(.base)],
        .feature(.timetable): [.feature(.base)],
        .feature(.myPage): [.feature(.base)],
        .feature(.base): [.domain, .designSystem],
        .domain: [.util],
        .data: [.domain],
        .network: [.data]
    ]
    
    private static let externalDependencyInfo: [Module: [ExternalModule]] = [
        .app: [.firebaseCore, .firebaseMessaging],
        .feature(.base): [.composableArchitecture],
        .util: [.dependencies]
    ]
    
    private var path: Path {
        switch self {
        case .feature: .relativeToRoot("Projects/Features/\(name)")
        default: .relativeToRoot("Projects/\(name)")
        }
    }
    
    var dependencies: [TargetDependency] {
        var allDependencies: [TargetDependency] = []
        
        if let dependencies = Module.dependencyInfo[self] {
            allDependencies += dependencies.map { module in
                TargetDependency.project(target: module.name, path: module.path)
            }
        }
        
        if let externalDependencies = Module.externalDependencyInfo[self] {
            allDependencies += externalDependencies.map { module in
                TargetDependency.external(name: module.name)
            }
        }
        return allDependencies
    }
}
