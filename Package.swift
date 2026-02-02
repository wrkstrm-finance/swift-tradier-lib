// swift-tools-version:6.1
import Foundation
import PackageDescription

ConfigurationService.local.dependencies = [
  .package(name: "wrkstrm-foundation", path: "../../../../../../../../wrkstrm/spm/universal/domain/system/wrkstrm-foundation"),
  .package(
    name: "wrkstrm-networking",
    path: "../../../../../../../../wrkstrm/spm/universal/domain/system/wrkstrm-networking"
  ),
  .package(name: "common-log", path: "../../../../universal/domain/system/common-log"),
  .package(name: "common-broker", path: "../common-broker"),
  .package(
    name: "wrkstrm-main",
    path: "../../../../../../../../wrkstrm/spm/universal/domain/system/wrkstrm-main"
  ),
  .package(name: "NotionLib", path: "../../../../../../../../wrkstrm/spm/universal/domain/finance/NotionLib"),
  .package(name: "JSONParserAdapters", path: "../../../../../../../../wrkstrm/spm/universal/domain/system/JSONParserAdapters"),
  .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.0"),
  .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.6.0"),
  .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
  .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.25.0"),
  .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
]

ConfigurationService.remote.dependencies = [
  .package(url: "https://github.com/wrkstrm/wrkstrm-foundation.git", from: "3.0.0"),
  .package(url: "https://github.com/wrkstrm/wrkstrm-networking.git", from: "3.0.0"),
  .package(url: "https://github.com/swift-universal/common-log.git", from: "3.0.0"),
  .package(name: "common-broker", path: "../common-broker"),
  .package(
    name: "wrkstrm-main",
    path: "../../../../../../../../wrkstrm/spm/universal/domain/system/wrkstrm-main"
  ),
  // Temporary: NotionLib is local-only.
  .package(name: "NotionLib", path: "../../../../../../../../wrkstrm/spm/universal/domain/finance/NotionLib"),
  .package(name: "JSONParserAdapters", path: "../../../../../../../../wrkstrm/spm/universal/domain/system/JSONParserAdapters"),
  .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.0"),
  .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.6.0"),
  .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
  .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.25.0"),
  .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
]

let package = Package(
  name: "swift-tradier-lib",
  platforms: [
    .iOS(.v17),
    .macOS(.v15),
    .macCatalyst(.v17),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(name: "TradierLib", targets: ["TradierLib"]),
    .library(name: "TradierBrokerageCommonAdapters", targets: ["TradierBrokerageCommonAdapters"]),
    .library(name: "TradierLibManagedObjects", targets: ["TradierLibManagedObjects"]),
    .executable(name: "tradier-json-perf-cli", targets: ["TradierJSONPerfCLI"]),
  ],
  dependencies: ConfigurationService.inject.dependencies,
  targets: [
    .target(
      name: "TradierLib",
      dependencies: [
        .product(name: "WrkstrmFoundation", package: "wrkstrm-foundation"),
        .product(name: "WrkstrmNetworking", package: "wrkstrm-networking"),
        .product(name: "CommonLog", package: "common-log"),
        .product(name: "NotionLib", package: "NotionLib"),
        .product(name: "WebSocketKit", package: "websocket-kit"),
        .product(name: "NIO", package: "swift-nio"),
        .product(name: "NIOHTTP1", package: "swift-nio"),
        .product(name: "NIOWebSocket", package: "swift-nio"),
        .product(name: "NIOSSL", package: "swift-nio-ssl"),
        .product(name: "Logging", package: "swift-log"),
      ],
      path: "sources/TradierLib",
    ),
    .target(
      name: "TradierBrokerageCommonAdapters",
      dependencies: [
        "TradierLib",
        .product(name: "CommonBroker", package: "common-broker"),
        .product(name: "WrkstrmFoundation", package: "wrkstrm-foundation"),
        .product(name: "WrkstrmMain", package: "wrkstrm-main"),
        .product(name: "WrkstrmNetworking", package: "wrkstrm-networking"),
        .product(name: "CommonLog", package: "common-log"),
      ],
      path: "sources/tradier-brokerage-common-adapters",
    ),
    .target(
      name: "TradierLibManagedObjects",
      dependencies: [
        "TradierLib",
        .product(name: "CommonLog", package: "common-log"),
      ],
      path: "sources/TradierLibManagedObjects",
      resources: [.process("Resources")],
    ),
    // Build test target dependency list conditionally based on local deps flag.
    .testTarget(
      name: "TradierLibTests",
      dependencies: [
        "TradierLib",
        .product(name: "WrkstrmFoundation", package: "wrkstrm-foundation"),
        .product(name: "WrkstrmNetworking", package: "wrkstrm-networking"),
        .product(name: "CommonLog", package: "common-log"),
        .product(name: "ReerJSONParserAdapter", package: "JSONParserAdapters"),
      ],
      path: "tests/TradierLibTests",
      resources: [.process("Resources")],
    ),
    .testTarget(
      name: "TradierBrokerageCommonAdaptersTests",
      dependencies: [
        "TradierBrokerageCommonAdapters",
        "TradierLib",
        .product(name: "CommonBroker", package: "common-broker"),
        .product(name: "WrkstrmNetworking", package: "wrkstrm-networking"),
      ],
      path: "tests/tradier-brokerage-common-adapters-tests",
      resources: [.process("Resources")],
    ),
    .testTarget(
      name: "TradierLibManagedObjectsTests",
      dependencies: [
        "TradierLibManagedObjects"
      ],
      path: "tests/TradierLibManagedObjectsTests",
    ),
    .executableTarget(
      name: "TradierJSONPerfCLI",
      dependencies: [
        "TradierLib",
        .product(name: "ReerJSONParserAdapter", package: "JSONParserAdapters"),
        .product(name: "WrkstrmFoundation", package: "wrkstrm-foundation"),
        .product(name: "WrkstrmMain", package: "wrkstrm-main"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      path: "sources/TradierJSONPerfCLI",
      swiftSettings: [
        .unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=10"])
      ],
    ),
  ],
)

@MainActor
public struct ConfigurationService {
  public static let version = "1.0.0"

  public var swiftSettings: [SwiftSetting] = []
  var dependencies: [Package.Dependency] = []

  public static let inject: ConfigurationService =
    ProcessInfo.useLocalDeps ? .local : .remote

  static var local: ConfigurationService =
    .init(swiftSettings: [.local])
  static var remote: ConfigurationService = .init()
}

extension SwiftSetting {
  public static let local: SwiftSetting = .unsafeFlags([
    "-Xfrontend",
    "-warn-long-expression-type-checking=10",
  ])
}

extension ProcessInfo {
  public static var useLocalDeps: Bool {
    ProcessInfo.processInfo.environment["SPM_USE_LOCAL_DEPS"] == "true"
  }
}

// CONFIG_SERVICE_END_V1
