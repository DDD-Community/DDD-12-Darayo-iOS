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
        let organizationName = ProjectInfo.organizationName.lowercased()
        let appName = ProjectInfo.appName.lowercased()
        let appBundleID = "com.\(organizationName).\(appName)"
        
        switch self {
        case .app: return appBundleID
        case .feature(let module):
            let moduleName = module.name.lowercased()
            return "\(appBundleID).feature.\(moduleName)"
        default:
            let moduleName = name.lowercased()
            return "\(appBundleID).\(moduleName)"
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
    case dependencies
    
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
