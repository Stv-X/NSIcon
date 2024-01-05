// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSIcon",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "NSIcon",
            targets: ["NSIcon"])
    ],
    targets: [
        .target(
            name: "NSIcon",
            resources: [.process("Resources")]),
        .testTarget(
            name: "NSIconTests",
            dependencies: ["NSIcon"])
    ]
)
