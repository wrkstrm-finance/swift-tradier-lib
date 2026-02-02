import Foundation
import Testing

@testable import TradierLib

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite
struct TradierClientTests {
  @Test
  func fetchAccountsParsesAccountNumbers() async throws {
    let configuration: URLSessionConfiguration = .ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]

    let json: Data = try Bundle.module.json(named: "user_profile")
    MockURLProtocol.handler = { (_: URLRequest) in
      let url: URL =
        .init(string: "https://sandbox.tradier.com/v1/user/profile") ?? .init(fileURLWithPath: "/")
      let response: HTTPURLResponse =
        .init(
          url: url,
          statusCode: 200,
          httpVersion: nil,
          headerFields: nil,
        )!
      return (response, json)
    }

    let client: TradierClient = .init(configuration: configuration)
    let accounts: [String] = try await client.fetchAccounts()
    #expect(accounts == ["VA000001", "VA000002"])
  }
}

final class MockURLProtocol: URLProtocol {
  nonisolated(unsafe) static var handler: (@Sendable (URLRequest) -> (HTTPURLResponse, Data))?
  override class func canInit(with _: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
  override func startLoading() {
    guard let handler = Self.handler else {
      client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
      return
    }
    let (response, data) = handler(request)
    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: data)
    client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {}
}
