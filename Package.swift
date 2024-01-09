// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSIcon",
    platforms: [
        .macOS(.v12), .iOS(.v15), .watchOS(.v9)
    ],
    products: [
        .library(
            name: "NSIcon",
            targets: ["NSIcon"])
    ],
    targets: [
        .target(
            name: "NSIcon"),
        .testTarget(
            name: "NSIconTests",
            dependencies: ["NSIcon"])
    ]
)
