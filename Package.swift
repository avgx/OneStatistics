// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OneStatistics",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .tvOS(.v18),
        .macOS(.v13),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "OneStatistics",
            targets: ["OneStatistics"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/CCTVThings.git", from: "1.0.0"),
        .package(url: "https://github.com/avgx/RequestResponse.git", from: "2.0.0"),
        .package(url: "https://github.com/avgx/SafeEnum.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "OneStatistics",
            dependencies: [
                .product(name: "CCTVThings", package: "CCTVThings"),
                .product(name: "RequestResponse", package: "RequestResponse"),
                .product(name: "SafeEnum", package: "SafeEnum"),
            ]
        ),
        .testTarget(
            name: "OneStatisticsTests",
            dependencies: [
                "OneStatistics",
                .product(name: "CCTVThings", package: "CCTVThings"),
                .product(name: "RequestResponse", package: "RequestResponse"),
                .product(name: "SafeEnum", package: "SafeEnum"),
                
            ]
        ),
    ]
)
