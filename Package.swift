// swift-tools-version:6.1
import Foundation
import PackageDescription

private func envBool(_ key: String) -> Bool {
  guard let raw = ProcessInfo.processInfo.environment[key] else { return false }
  switch raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
  case "1", "true", "yes":
    return true
  default:
    return false
  }
}

private let packageDir: URL = URL(fileURLWithPath: #filePath)
  .deletingLastPathComponent()

private func resolvedPath(_ path: String) -> String {
  if path.hasPrefix("/") { return path }
  return packageDir.appendingPathComponent(path).standardizedFileURL.path
}

private let useLocalDeps: Bool = envBool("SPM_USE_LOCAL_DEPS")

private func localOrRemote(path: String, url: String, from version: Version) -> Package.Dependency {
  if useLocalDeps {
    return .package(path: resolvedPath(path))
  }
  return .package(url: url, from: version)
}

ConfigurationService.local.dependencies = [
  .package(path: resolvedPath("../../../../../../../wrkstrm/private/universal/spm/domain/system/wrkstrm-networking")),
  .package(
    path: resolvedPath("../../../../../../../swift-universal/private/universal/domain/system/spm/swift-universal-foundation")
  ),
  .package(path: resolvedPath("../../../../../../../swift-universal/private/universal/spm/domain/system/common-log")),
  .package(path: resolvedPath("../common-broker")),
  .package(
    path: resolvedPath("../../../../../../../swift-universal/private/universal/domain/system/spm/swift-universal-main")
  ),
  // NotionLib lives in the wrkstrm mono tree (no standalone repo yet).
  .package(path: resolvedPath("../../../../../../../wrkstrm/public/universal/spm/domain/api/notion-lib")),
  .package(path: resolvedPath("../../../../../../../wrkstrm/public/universal/spm/domain/system/JSONParserAdapters")),
  .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.0"),
  .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.6.0"),
  .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
  .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.25.0"),
  .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
]

ConfigurationService.remote.dependencies = [
  .package(url: "https://github.com/wrkstrm/wrkstrm-networking.git", from: "3.0.5"),
  .package(url: "https://github.com/swift-universal/swift-universal-foundation.git", from: "3.0.0"),
  .package(url: "https://github.com/swift-universal/common-log.git", from: "3.0.0"),
  .package(url: "https://github.com/wrkstrm-finance/common-broker.git", from: "0.1.6"),
  .package(url: "https://github.com/swift-universal/swift-universal-main.git", from: "3.0.0"),
  // NotionLib is currently mono-only (no standalone repo); keep as a local path even in remote mode.
  .package(path: resolvedPath("../../../../../../../wrkstrm/public/universal/spm/domain/api/notion-lib")),
  .package(path: resolvedPath("../../../../../../../wrkstrm/public/universal/spm/domain/system/JSONParserAdapters")),
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
        .product(name: "SwiftUniversalMain", package: "swift-universal-main"),
        .product(name: "SwiftUniversalFoundation", package: "swift-universal-foundation"),
        .product(name: "WrkstrmNetworking", package: "wrkstrm-networking"),
        .product(name: "CommonLog", package: "common-log"),
        .product(name: "NotionLib", package: "notion-lib"),
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
        .product(name: "SwiftUniversalFoundation", package: "swift-universal-foundation"),
        .product(name: "SwiftUniversalMain", package: "swift-universal-main"),
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
        .product(name: "WrkstrmNetworking", package: "wrkstrm-networking"),
        .product(name: "SwiftUniversalMain", package: "swift-universal-main"),
        .product(name: "SwiftUniversalFoundation", package: "swift-universal-foundation"),
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
        .product(name: "SwiftUniversalMain", package: "swift-universal-main"),
        .product(name: "SwiftUniversalFoundation", package: "swift-universal-foundation"),
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
  public static let version = "0.2.6"

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
    guard let raw = ProcessInfo.processInfo.environment["SPM_USE_LOCAL_DEPS"] else { return false }
    let normalized = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    return normalized == "1" || normalized == "true" || normalized == "yes"
  }
}

// CONFIG_SERVICE_END_V1
