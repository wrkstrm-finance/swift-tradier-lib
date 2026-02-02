import Foundation
import Testing
import WrkstrmFoundation
import WrkstrmMain
import WrkstrmNetworking

@testable import TradierLib

// Fake transport that returns a canned UserProfile JSON and 200 OK.
private struct FakeTransport: HTTP.Transport {
  let data: Data
  func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
    let response = HTTPURLResponse(
      url: request.url!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: ["Content-Type": "application/json"],
    )!
    return (data, response)
  }
}

// Decoder that records decode calls and delegates to a real JSONDecoder.
struct StubUserProfileDecoder: JSONDataDecoding {
  let base: JSONDecoder = .commonDateParsing
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    if type == Tradier.UserProfileRoot.self {
      let stub = Tradier.UserProfileRoot(
        profile: Tradier.UserProfile(accounts: [], id: "stub", name: "stub"),
      )
      // Force-cast to satisfy the generic return
      return unsafeBitCast(stub, to: T.self)
    }
    return try base.decode(T.self, from: data)
  }
}

@Suite("Custom JSON decoder injection")
struct CustomDecoderInjectionTests {
  @Test
  func userProfile_usesInjectedDecoder() async throws {
    // Arrange canned payload
    let json = """
      { "profile": { "name": "Jane Doe", "id": "u1" } }
      """.data(using: .utf8)!

    let env = Tradier.HTTPSSandboxEnvironment()
    let transport = FakeTransport(data: json)
    let client = HTTP.CodableClient(
      environment: env,
      jsonCoding: (
        requestEncoder: JSONEncoder.commonDateFormatting,
        responseDecoder: StubUserProfileDecoder(),
      ),
      transport: transport,
    )

    let service = Tradier.CodableService(client: client)

    // Act
    let profile = try await service.userProfile()
    // Expect stubbed id, proving our custom decoder was used.
    #expect(profile.id == "stub")
  }
}
