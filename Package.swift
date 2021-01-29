// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftCSVExport",
    platforms: [.macOS(.v10_10), .iOS(.v8)],
    products: [.library(name: "SwiftCSVExport", targets: ["SwiftCSVExport"])],
    targets: [
        .target(
            name: "SwiftCSVExport",
            path: "Sources"
        )
    ]
)
