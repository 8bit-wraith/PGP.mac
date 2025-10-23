// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// PGP.mac - Making encryption sexy again!
// Because copying keys between apps shouldn't feel like performing surgery

// Partners: Hue & Aye @ 8b.is

import PackageDescription

let package = Package(
    name: "PGPmac",
    platforms: [
        .macOS(.v13)  // Using the latest stable macOS version for all the SwiftUI goodness
    ],
    products: [
        // The main macOS application
        .executable(
            name: "PGPmac",
            targets: ["PGPmac"]
        ),
        // Core library that handles all the crypto magic
        .library(
            name: "PGPCore",
            targets: ["PGPCore"]
        )
    ],
    dependencies: [
        // We'll use ObjectivePGP for native Swift PGP operations
        // It's pure Swift, no need for GPGMe bindings - cleaner and more modern!
        .package(url: "https://github.com/krzyzanowskim/ObjectivePGP.git", from: "0.99.4")
    ],
    targets: [
        // The main app target - where the SwiftUI magic happens
        .executableTarget(
            name: "PGPmac",
            dependencies: ["PGPCore"],
            path: "Sources/App",
            resources: [
                .process("Resources")
            ]
        ),

        // Core crypto operations - the brains of the operation
        .target(
            name: "PGPCore",
            dependencies: [
                .product(name: "ObjectivePGP", package: "ObjectivePGP")
            ],
            path: "Sources/Core"
        ),

        // Tests - because we don't want to accidentally encrypt cat photos with the wrong key
        .testTarget(
            name: "PGPCoreTests",
            dependencies: ["PGPCore"],
            path: "Tests/CoreTests"
        )
    ]
)
