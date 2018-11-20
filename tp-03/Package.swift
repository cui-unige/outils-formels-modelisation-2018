// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "StructuralExtensions",
  products: [
    .executable(name: "structext", targets: ["structext"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "structext", dependencies: ["Inhibitor"]),
    .target(name: "Inhibitor"),
    .testTarget(name: "InhibitorTests", dependencies: ["Inhibitor"])
  ]
)
