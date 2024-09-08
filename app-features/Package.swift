// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "app-features",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Common", targets: ["Common"]),
        .library(name: "CommonUI", targets: ["CommonUI"]),
        .library(name: "ConvertFeature", targets: ["ConvertFeature"]),
        .library(name: "ConvertUI", targets: ["ConvertUI"]),
        .library(name: "CurrenciesFeature", targets: ["CurrenciesFeature"]),
        .library(name: "CurrenciesUI", targets: ["CurrenciesUI"]),
        .library(name: "DetailsFeature", targets: ["DetailsFeature"]),
        .library(name: "DetailsUI", targets: ["DetailsUI"]),
        .library(name: "ExchangeRatesFeature", targets: ["ExchangeRatesFeature"]),
        .library(name: "ExchangeRatesUI", targets: ["ExchangeRatesUI"]),
        .library(name: "MainFeature", targets: ["MainFeature"]),
        .library(name: "MainUI", targets: ["MainUI"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.13.0"),
        .package(url: "https://github.com/pointfreeco/swift-overture", from: "0.5.0"),
        .package(url: "https://github.com/madebybowtie/FlagKit.git", from: "2.3.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/przemyslaw-cygan/currency-api", from: "0.0.1"),
        .package(path: "../app-ui-components"),
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FlagKit", package: "FlagKit"),
                .product(name: "CurrencyAPI", package: "currency-api"),
                .product(name: "CurrencyAPIData", package: "currency-api"),
                .product(name: "CurrencyAPILive", package: "currency-api"),
                .product(name: "CurrencyAPIStub", package: "currency-api"),
            ]
        ),
        .target(
            name: "CommonUI",
            dependencies: [
                .product(name: "Overture", package: "swift-overture"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "AppUIComponents", package: "app-ui-components"),
            ]
        ),
        .target(
            name: "ConvertFeature",
            dependencies: [
                .target(name: "Common"),
                .target(name: "CurrenciesFeature"),
            ]
        ),
        .target(
            name: "ConvertUI",
            dependencies: [
                .target(name: "CommonUI"),
                .target(name: "CurrenciesUI"),
                .target(name: "ConvertFeature"),
            ]
        ),
        .target(
            name: "CurrenciesFeature",
            dependencies: [
                .target(name: "Common"),
            ]
        ),
        .target(
            name: "CurrenciesUI",
            dependencies: [
                .target(name: "CommonUI"),
                .target(name: "CurrenciesFeature"),
            ]
        ),
        .target(
            name: "DetailsFeature",
            dependencies: [
                .target(name: "Common"),
                .target(name: "ConvertFeature"),
            ]
        ),
        .target(
            name: "DetailsUI",
            dependencies: [
                .target(name: "CommonUI"),
                .target(name: "ConvertUI"),
                .target(name: "DetailsFeature"),
            ]
        ),
        .target(
            name: "ExchangeRatesFeature",
            dependencies: [
                .target(name: "Common"),
                .target(name: "DetailsFeature"),
            ]
        ),
        .target(
            name: "ExchangeRatesUI",
            dependencies: [
                .target(name: "CommonUI"),
                .target(name: "DetailsUI"),
                .target(name: "ExchangeRatesFeature"),
            ]
        ),
        .target(
            name: "MainFeature",
            dependencies: [
                .target(name: "Common"),
                .target(name: "ConvertFeature"),
                .target(name: "ExchangeRatesFeature"),
                .target(name: "SettingsFeature"),
            ]
        ),
        .target(
            name: "MainUI",
            dependencies: [
                .target(name: "CommonUI"),
                .target(name: "ConvertUI"),
                .target(name: "ExchangeRatesUI"),
                .target(name: "SettingsUI"),
                .target(name: "MainFeature"),
            ]
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                .target(name: "Common"),
                .target(name: "CurrenciesFeature"),
            ]
        ),
        .target(
            name: "SettingsUI",
            dependencies: [
                .target(name: "CommonUI"),
                .target(name: "CurrenciesUI"),
                .target(name: "SettingsFeature"),
            ]
        ),
        .testTarget(
            name: "ConvertFeatureTests",
            dependencies: [
                .target(name: "ConvertFeature")
            ]
        ),
        .testTarget(
            name: "CurrenciesFeatureTests",
            dependencies: [
                .target(name: "CurrenciesFeature")
            ]
        ),
    ]
)
