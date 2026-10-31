// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "ViewsNativeCore", platforms: [.macOS(.v12)], products: [.library(name: "ViewsCore", targets: ["ViewsCore"])], dependencies: [.package(path: "vendor/ZIPFoundation")], targets: [
    .target(name: "ViewsNative", path: "Native", publicHeadersPath: "include", cSettings: [.headerSearchPath("../vendor/brotli/c/include")], linkerSettings: [.linkedLibrary("z"), .linkedLibrary("crypto", .when(platforms: [.linux]))]),
    .target(name: "ViewsCore", dependencies: ["ViewsNative", .product(name: "ZIPFoundation", package: "ZIPFoundation")], path: "Sources/Core"),
    .testTarget(name: "ViewsCoreTests", dependencies: ["ViewsCore"], path: "Tests", exclude: ["Fixtures"])
])
