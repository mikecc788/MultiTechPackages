// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MultiTechPackages",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "BluetoothKit", targets: ["BluetoothKit"]),
        .library(name: "NetworkKit", targets: ["NetworkKit"]),
    ],
    targets: [
        // BluetoothKit
        .target(
            name: "BluetoothKit",
            path: "BluetoothKit/Sources/BluetoothKit"
        ),
        .testTarget(
            name: "BluetoothKitTests",
            dependencies: ["BluetoothKit"],
            path: "BluetoothKit/Tests/BluetoothKitTests"
        ),

        // NetworkKit
        .target(
            name: "NetworkKit",
            path: "NetworkKit/Sources/NetworkKit"
        ),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKit"],
            path: "NetworkKit/Tests/NetworkKitTests"
        )
    ]
)
