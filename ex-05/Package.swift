// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "FormalDefinitions",
  dependencies: [
    .package(url: "https://github.com/kyouko-taiga/PetriKit.git", from: "2.0.0"),
  ],
  targets: [
    .target(name: "FormalDefinitions", dependencies: ["PetriKit"]),
  ]
)
