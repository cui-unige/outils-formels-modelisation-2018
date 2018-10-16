// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Hello",
    dependencies: [
    ],
    targets: [
        .target(
            name: "Hello",
            dependencies: []),
        .testTarget(
            name: "HelloTests",
            dependencies: ["Hello"]),
    ]
)
