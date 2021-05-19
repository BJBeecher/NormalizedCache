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
        .package(name: "Cache", url: "https://github.com/BJBeecher/Cache.git", .upToNextMajor(from: "1.0.1"))
    ],
    targets: [
        .target(
            name: "UpdateCache",
            dependencies: ["Cache"]),
        .testTarget(
            name: "UpdateCacheTests",
            dependencies: ["UpdateCache"]),
    ]
)
