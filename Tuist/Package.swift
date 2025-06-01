// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers
    
    let packageSettings = PackageSettings(
        productTypes: [:],
        baseSettings: .settings(configurations: .default)
    )
#endif

let package = Package(
    name: "Darayo",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.20.2")
    ]
)
