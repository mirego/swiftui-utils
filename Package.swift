// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIUtils",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftUIUtils",
            targets: ["SwiftUIUtils"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Cocoanetics/DTCoreText.git", from: "1.6.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIUtils",
            dependencies: ["DTCoreText"],
            path: "Sources"
        )
    ]
)
