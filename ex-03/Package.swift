// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "Properties",
  dependencies: [
    .package(url: "https://github.com/kyouko-taiga/PetriKit.git", from: "2.0.0"),
  ],
  targets: [
    .target(name: "Properties", dependencies: ["PetriKit"]),
  ])
