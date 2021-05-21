// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NormalizedCache",
    products: [.library(name: "NormalizedCache", targets: ["NormalizedCache"])],
    dependencies: [.package(name: "Cache", url: "https://github.com/BJBeecher/Cache.git", .upToNextMajor(from: "1.0.1"))],
    targets: [
        .target(name: "NormalizedCache", dependencies: ["Cache"]),
        .testTarget(name: "NormalizedCacheTests", dependencies: ["NormalizedCache"])
    ]
)
