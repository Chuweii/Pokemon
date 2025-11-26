// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pokemon",
    platforms: [.iOS("17.0")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Pokemon",
            targets: ["Pokemon"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            exact: "1.17.0"
        ),
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            exact: "5.8.0"
        ),
        .package(
            url: "https://github.com/Moya/Moya.git",
            exact: "15.0.3"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Pokemon",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Moya", package: "Moya")
            ]
        ),
        .testTarget(
            name: "PokemonTests",
            dependencies: [
                "Pokemon",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Moya", package: "Moya")
            ]
        ),
    ]
)
