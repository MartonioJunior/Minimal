// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Utilities
public enum UpcomingFeatures: String, CaseIterable {
    case existentialAny
    case fullTypedThrows
    case internalImportsByDefault
    case memberImportVisibility
    case nonescapableTypes
    case nonisolatedNonsendingByDefault
    case inferIsolatedConformances
    case valueGenerics

    var asSetting: SwiftSetting { .enableUpcomingFeature(rawValue.prefix(1).uppercased() + rawValue.dropFirst()) }
}

public extension Array where Element == SwiftSetting {
    static var upcomingFeatures: Self { UpcomingFeatures.allCases.map(\.asSetting) }
}

func dep(local: String) -> Package.Dependency {
    .package(path: local)
}

func dep(url: String, _ version: Range<Version>, local: String = "") -> Package.Dependency {
    if local.isEmpty {
        .package(url: url, version)
    } else {
        dep(local: local)
    }
}

func lib(_ name: String, targets: String...) -> Product {
    .library(name: name, targets: targets)
}

func platformDeps(_ platforms: SupportedPlatform...) -> [SupportedPlatform] {
    platforms
}

func targetDep(name: String, package: String) -> Target.Dependency {
    .product(name: name, package: package)
}

// MARK: - Dependencies
let overture = targetDep(name: "Overture", package: "swift-overture")

let dependencies = [
    dep(url: "https://github.com/pointfreeco/swift-overture", .upToNextMajor(from: "0.5.0"))
]

// MARK: - Targets
var targets: [Target] = [
    .target(
        name: "Functional",
        dependencies: [overture],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Global",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Operators",
        dependencies: [overture],
        swiftSettings: .upcomingFeatures
    )
]

let testTargets: [Target] = targets.map { t in
    .testTarget(name: "\(t.name)Tests", dependencies: [Target.Dependency(stringLiteral: t.name)] + t.dependencies)
}

targets.append(
    .target(
        name: "Minimal",
        dependencies: targets.map { .init(stringLiteral: $0.name) },
        swiftSettings: .upcomingFeatures
    )
)

// MARK: - Products
let products: [Product] = [
    .library(
        name: "Minimal",
        targets: targets.map(\.name)
    )
]

// MARK: - PackageDescription
let package = Package(
    name: "Minimal",
    products: products,
    dependencies: dependencies,
    targets: targets + testTargets,
    swiftLanguageModes: [.v6]
)
