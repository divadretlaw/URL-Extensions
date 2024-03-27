// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "URL+Extensions",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "URLExtensions",
            targets: ["URLExtensions"]
        )
    ],
    targets: [
        .target(
            name: "URLExtensions"
        ),
        .testTarget(
            name: "URLExtensionsTests",
            dependencies: ["URLExtensions"]
        )
    ]
)
