// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StateMachine",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "StateMachine",
            targets: ["StateMachine"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble", from: "11.2.1")
    ],
    targets: [
        .target(
            name: "StateMachine",
            dependencies: []),
        .testTarget(
            name: "StateMachineTests",
            dependencies: ["StateMachine", "Nimble"]),
    ]
)
