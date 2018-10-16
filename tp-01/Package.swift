// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "Sema",
  dependencies: [
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    .target(name: "Sema", dependencies: ["SemaLib"]),
    .target(name: "SemaLib", dependencies: []),
    .testTarget(name: "SemaLibTests", dependencies: ["SemaLib"]),
  ]
)
