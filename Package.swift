// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NormalizedCache",
    platforms: [.iOS(.v13)],
    products: [.library(name: "NormalizedCache", targets: ["NormalizedCache"])],
    dependencies: [],
    targets: [
        .target(name: "NormalizedCache", dependencies: []),
        .testTarget(name: "NormalizedCacheTests", dependencies: ["NormalizedCache"])
    ]
)
