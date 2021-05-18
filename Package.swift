// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UpdateCache",
    products: [
        .library(
            name: "UpdateCache",
            targets: ["UpdateCache"]),
    ],
    dependencies: [
        .package(name: "CacheKit", url: "https://github.com/BJBeecher/CacheKit.git", .upToNextMajor(from: "1.0.1"))
    ],
    targets: [
        .target(
            name: "UpdateCache",
            dependencies: ["CacheKit"]),
        .testTarget(
            name: "UpdateCacheTests",
            dependencies: ["UpdateCache"]),
    ]
)
