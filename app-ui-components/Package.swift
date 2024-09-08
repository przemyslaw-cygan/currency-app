// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "app-ui-components",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AppUIComponents",
            targets: ["AppUIComponents"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-overture", from: "0.5.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
    ],
    targets: [
        .target(
            name: "AppUIComponents",
            dependencies: [
                .product(name: "Overture", package: "swift-overture"),
                .product(name: "SnapKit", package: "SnapKit"),
            ]
        ),
    ]
)
