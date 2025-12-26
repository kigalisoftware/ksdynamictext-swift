// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KSDynamicText",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "KSDynamicText",
            targets: ["KSDynamicText"]),
    ],
    targets: [
        .target(
            name: "KSDynamicText",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "KSDynamicTextTests",
            dependencies: ["KSDynamicText"]),
    ]
)
