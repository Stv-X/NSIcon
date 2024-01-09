// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSIcon",
    platforms: [
        .iOS(.v15), .macOS(.v12), .watchOS(.v8)
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
