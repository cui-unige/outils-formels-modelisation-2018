// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "PropositionalLogic",
  products: [
    .executable(name: "Sandbox", targets: ["Sandbox"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "PropositionalLogic"),
    .target(name: "Sandbox", dependencies: ["PropositionalLogic"]),
    .testTarget(name: "PropositionalLogicTests", dependencies: ["PropositionalLogic"]),
  ])
