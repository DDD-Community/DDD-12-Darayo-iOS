//
//  ProjectInfo.swift
//  ProjectDescriptionHelpers
//
//  Created by 이정원 on 6/1/25.
//

import ProjectDescription

public enum ProjectInfo {
    public static let organizationName: String = "Darayo"
    public static let appName: String = "Festibee"
    public static let destinations: Destinations = [.iPhone]
    public static let deploymentTargets: DeploymentTargets = .iOS("17.0")
}
