// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "app-dependencies",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AppDependencies",
            targets: ["AppDependencies"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.13.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", from: "6.5.0"),
        .package(path: "../app-features"),
    ],
    targets: [
        .target(
            name: "AppDependencies",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                .product(name: "MainFeature", package: "app-features"),
                .product(name: "MainUI", package: "app-features"),
            ]
        )
    ]
)
