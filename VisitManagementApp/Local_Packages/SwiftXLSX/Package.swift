// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftXLSX",
    platforms: [
        .iOS(.v16),
    //  .iOS(.v15),
    //  .iOS("15.5"),
    //  .iOS(.v10),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "SwiftXLSX",
            targets: ["SwiftXLSX"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", "2.3.0"..<"3.1.0")
    ],
    targets: [
        .target(
            name: "SwiftXLSX",
            dependencies: ["ZipArchive"]),
        .testTarget(
            name: "SwiftXLSXTests",
            dependencies: ["SwiftXLSX"]),
    ]
)
