// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComposableUIKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "ComposableUIKit", targets: ["ComposableUIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.52.0"),
    ],
    targets: [
        .target(
            name: "ComposableUIKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
