// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "StateSpace",
  products: [
    .library(name: "StateSpace", targets: ["StateSpace"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "StateSpace", dependencies: []),
    .testTarget(name: "StateSpaceTests", dependencies: ["StateSpace"]),
  ]
)
