//
//  FeatureModule.swift
//  Templates
//
//  Created by 이정원 on 6/5/25.
//

import ProjectDescription

let template = Template(
    description: "A template for creating a new feature module",
    attributes: [
        .required("moduleName"),
        .required("author"),
        .required("date")
    ],
    items: [
        .string(path: "Projects/Features/{{ moduleName }}/Sources/Source.swift", contents: "// Source"),
        .string(
            path: "Projects/Features/{{ moduleName }}/Project.swift",
            contents: """
            //
            //  Project.swift
            //  AppManifests
            //
            //  Created by {{ author }} on {{ date }}.
            //

            import ProjectDescription
            import ProjectDescriptionHelpers

            let project = Project(module: .feature(.{{ moduleName|lowercase }}))
            """
        )
    ]
)
