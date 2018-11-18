// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "PetriKit",
  products: [
    .library(name: "PetriKit", targets: ["PetriKit"]),
  ],
  targets: [
    .target(name: "PetriKit"),
    .testTarget(name: "PetriKitTests", dependencies: ["PetriKit"]),
  ]
)
