// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "WeatherSDK",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "WeatherSDK",
            targets: ["WeatherSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "WeatherSDK",
            dependencies: [],
            path: "Sources/"
        ),
        .testTarget(
            name: "WeatherSDKTests",
            dependencies: ["WeatherSDK", .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")],
            path: "Tests/WeatherSDKTests"
        )
    ]
)
