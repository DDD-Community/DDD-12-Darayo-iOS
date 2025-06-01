//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

public enum Module: Hashable, Sendable {
    case app
    case feature(FeatureModule)
    case domain
    case data
    case network
    case util
    case designSystem
    
    public var name: String {
        switch self {
        case .app: ProjectInfo.appName
        case .feature(let module): module.name
        default: "\(self)".capitalized
        }
    }
    
    public var bundleID: String {
        switch self {
        case .app:
            return "com.ddd.\(ProjectInfo.organizationName.lowercased())"
        default:
            let appName = ProjectInfo.appName.lowercased()
            let moduleName = name.lowercased()
            return "com.\(appName).\(moduleName)"
        }
        
    }
}

public enum FeatureModule: Sendable {
    case root
    case base
    
    public var name: String {
        "\(self)".capitalized
    }
}

public enum ExternalModule: Sendable {
    case composableArchitecture
    
    public var name: String {
        "\(self)".capitalized
    }
}

private extension String {
    var capitalized: String {
        guard let first else { return self }
        return String(first).uppercased() + dropFirst()
    }
}
