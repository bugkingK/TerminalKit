// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TerminalKit",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .library(name: "TerminalKit", targets: ["TerminalKit"])
    ],
    targets: [
        .target(name: "TerminalKit", dependencies: []),
        .testTarget(name: "TerminalKitTests", dependencies: ["TerminalKit"])
    ],
    swiftLanguageVersions: [.v5]
)
