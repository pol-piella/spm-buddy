// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SPMBuddy",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.4")
    ],
    targets: [
        .executableTarget(
            name: "SPMBuddy",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "SPMBuddyCore"
        ),
        .testTarget(
            name: "SPMBuddyCoreTests",
            dependencies: ["SPMBuddyCore"]
        )
    ]
)
