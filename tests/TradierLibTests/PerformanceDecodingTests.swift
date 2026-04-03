import Foundation
import Testing
import SwiftUniversalFoundation
import SwiftUniversalMain

@testable import TradierLib

#if canImport(ReerJSONParserAdapter)
import ReerJSONParserAdapter
#endif

@Suite("JSON decoding performance comparisons")
struct PerformanceDecodingTests {
  @Test
  func compareUserProfileDecoding() throws {
    // Load sample payload (existing test resource)
    let bundle = Bundle.module
    guard let url = bundle.url(forResource: "user_profile", withExtension: "json") else {
      Issue.record("Missing user_profile.json resource")
      return
    }
    let data = try Data(contentsOf: url)

    // Baseline: Foundation JSONDecoder
    let foundationDecoder = JSONDecoder.commonDateParsing
    let foundationStart = CFAbsoluteTimeGetCurrent()
    var fCount = 0
    for _ in 0..<200 {  // warm + repeat
      _ = try foundationDecoder.decode(Tradier.TradierBrokerageUserProfileRootModel.self, from: data)
      fCount += 1
    }
    let foundationElapsed = CFAbsoluteTimeGetCurrent() - foundationStart

    // Reer: via JSON.Parser adapter (if available)
    #if canImport(ReerJSONParserAdapter)
    let parser = ReerJSONParserAdapter.makeParser()
    let reerStart = CFAbsoluteTimeGetCurrent()
    var rCount = 0
    for _ in 0..<200 {
      _ = try parser.decode(Tradier.TradierBrokerageUserProfileRootModel.self, from: data)
      rCount += 1
    }
    let reerElapsed = CFAbsoluteTimeGetCurrent() - reerStart

    // Report metrics in test output
    print(
      "Foundation: \(fCount) decodes in \(foundationElapsed)s (\(foundationElapsed / Double(fCount))s/op)",
    )
    print("ReerJSON:  \(rCount) decodes in \(reerElapsed)s (\(reerElapsed / Double(rCount))s/op)")

    // Sanity: both decode successfully; avoid strict perf assertions in CI.
    #expect(fCount == 200)
    #expect(rCount == 200)
    #else
    print("ReerJSONParserAdapter not available; skipping comparison.")
    #expect(fCount == 200)
    #endif
  }

  @Test
  func frameBudget144Hz_runsPerFrame() throws {
    // 144 Hz frame budget (~6.944 ms)
    let frameBudget = 1.0 / 144.0

    let bundle = Bundle.module
    guard let url = bundle.url(forResource: "user_profile", withExtension: "json") else {
      Issue.record("Missing user_profile.json resource")
      return
    }
    let data = try Data(contentsOf: url)

    func runsWithinBudget(_ decode: () throws -> some Any) rethrows -> Int {
      let start = CFAbsoluteTimeGetCurrent()
      var count = 0
      while (CFAbsoluteTimeGetCurrent() - start) < frameBudget {
        _ = try decode()
        count += 1
      }
      return count
    }

    // Foundation baseline
    let foundationDecoder = JSONDecoder.commonDateParsing
    let fRuns = try runsWithinBudget {
      try foundationDecoder.decode(Tradier.TradierBrokerageUserProfileRootModel.self, from: data)
    }

    // ReerJSON via JSON.Parser (if available)
    #if canImport(ReerJSONParserAdapter)
    let parser = ReerJSONParserAdapter.makeParser()
    let rRuns = try runsWithinBudget {
      try parser.decode(Tradier.TradierBrokerageUserProfileRootModel.self, from: data)
    }
    print("144Hz frame budget: Foundation runs/frame=\(fRuns), ReerJSON runs/frame=\(rRuns)")
    #else
    print("144Hz frame budget: Foundation runs/frame=\(fRuns). ReerJSONParserAdapter unavailable.")
    #endif

    #expect(fRuns > 0)
  }

  @Test
  func reerAfterFoundationWarmup_runsPerOp() throws {
    #if canImport(ReerJSONParserAdapter)
    // Use a heavier payload to make effects more visible
    let bundle = Bundle.module
    guard let url = bundle.url(forResource: "option_chain", withExtension: "json") else {
      Issue.record("Missing option_chain.json resource")
      return
    }
    let data = try Data(contentsOf: url)

    let foundation = JSONDecoder.commonDateParsing
    let reer = ReerJSONParserAdapter.makeParser()

    func measureOps(duration: Double, _ decode: () throws -> Void) rethrows -> (
      ops: Int, perOp: Double
    ) {
      let start = CFAbsoluteTimeGetCurrent()
      var count = 0
      while (CFAbsoluteTimeGetCurrent() - start) < duration {
        try decode()
        count += 1
      }
      let elapsed = CFAbsoluteTimeGetCurrent() - start
      return (count, elapsed / Double(max(1, count)))
    }

    // 1) Baseline ReerJSON
    let pre = try measureOps(duration: 0.5) {
      _ = try reer.decode(Tradier.TradierBrokerageOptionChainRootModel.self, from: data)
    }

    // 2) Foundation warm-up ("MANY runs")
    _ = try measureOps(duration: 2.0) {
      _ = try foundation.decode(Tradier.TradierBrokerageOptionChainRootModel.self, from: data)
    }

    // 3) Post-warm ReerJSON
    let post = try measureOps(duration: 0.5) {
      _ = try reer.decode(Tradier.TradierBrokerageOptionChainRootModel.self, from: data)
    }

    let preNs = pre.perOp * 1e9
    let postNs = post.perOp * 1e9
    let delta = ((preNs - postNs) / preNs) * 100.0
    print(
      String(
        format: "ReerJSON per-op (ns): pre=%.0f post=%.0f Δ=%.1f%% (ops: pre=%d post=%d)", preNs,
        postNs, delta, pre.ops, post.ops,
      ))

    #else
    print("ReerJSONParserAdapter unavailable in this test configuration; skipping warmup comparison.")
    return
    #endif
  }

  @Test
  func aggregateAcrossPayloads_frameStats_CSV() throws {
    // Prepare payloads and decode closures
    struct Payload<T: Decodable> {
      let name: String
      let data: Data
      let type: T.Type
    }
    let bundle = Bundle.module

    func load(_ name: String) throws -> Data {
      guard let url = bundle.url(forResource: name, withExtension: "json") else {
        throw StringError("Missing resource: \(name).json")
      }
      return try Data(contentsOf: url)
    }

    let payloads: [Any] = try [
      Payload(
        name: "user_profile", data: load("user_profile"), type: Tradier.TradierBrokerageUserProfileRootModel.self,
      ),
      Payload(name: "positions", data: load("positions"), type: Tradier.TradierBrokeragePositionsRootModel.self),
      Payload(
        name: "positions_large", data: load("positions_large"), type: Tradier.TradierBrokeragePositionsRootModel.self,
      ),
      Payload(
        name: "option_expirations", data: load("option_expirations"),
        type: Tradier.TradierBrokerageOptionExpirationsRootModel.self,
      ),
      Payload(name: "quotes", data: load("quotes"), type: Tradier.TradierBrokerageSingleQuoteRootModel.self),
      Payload(
        name: "option_chain", data: load("option_chain"), type: Tradier.TradierBrokerageOptionChainRootModel.self,
      ),
    ]

    // Stats helpers
    func median(_ values: [Double]) -> Double {
      guard !values.isEmpty else { return 0 }
      let s = values.sorted()
      let mid = s.count / 2
      return s.count % 2 == 0 ? (s[mid - 1] + s[mid]) / 2.0 : s[mid]
    }
    func p95(_ values: [Double]) -> Double {
      guard !values.isEmpty else { return 0 }
      let s = values.sorted()
      let idx = Int(Double(s.count - 1) * 0.95)
      return s[max(0, min(idx, s.count - 1))]
    }

    func runsWithinBudget(_ decode: () throws -> some Any, windows: Int, budget: Double) rethrows
      -> [Double]
    {
      var results: [Double] = []
      results.reserveCapacity(windows)
      for _ in 0..<windows {
        let start = CFAbsoluteTimeGetCurrent()
        var count = 0.0
        while (CFAbsoluteTimeGetCurrent() - start) < budget {
          _ = try decode()
          count += 1.0
        }
        results.append(count)
      }
      return results
    }

    let budget = 1.0 / 144.0
    let windows = 25
    let foundation = JSONDecoder.commonDateParsing

    #if canImport(ReerJSONParserAdapter)
    let reer = ReerJSONParserAdapter.makeParser()
    #endif

    var csv = ["payload,engine,mean,median,p95"]

    func report<T>(_ p: Payload<T>) throws {
      // Foundation
      let fRuns = try runsWithinBudget(
        { try foundation.decode(T.self, from: p.data) }, windows: windows, budget: budget,
      )
      let fMean = fRuns.reduce(0, +) / Double(fRuns.count)
      csv.append(
        "\(p.name),foundation,\(String(format: "%.2f", fMean)),\(String(format: "%.2f", median(fRuns))),\(String(format: "%.2f", p95(fRuns)))",
      )

      // Reer
      #if canImport(ReerJSONParserAdapter)
      let rRuns = try runsWithinBudget(
        { try reer.decode(T.self, from: p.data) }, windows: windows, budget: budget,
      )
      let rMean = rRuns.reduce(0, +) / Double(rRuns.count)
      csv.append(
        "\(p.name),reerjson,\(String(format: "%.2f", rMean)),\(String(format: "%.2f", median(rRuns))),\(String(format: "%.2f", p95(rRuns)))",
      )
      #endif
    }

    // Iterate typed payloads via a switch cast
    for anyP in payloads {
      if let p = anyP as? Payload<Tradier.TradierBrokerageUserProfileRootModel> {
        try report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokeragePositionsRootModel> {
        try report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokerageOptionExpirationsRootModel> {
        try report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokerageSingleQuoteRootModel> {
        try report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokerageOptionChainRootModel> {
        try report(p)
      }
    }

    // Write CSV to /tmp and echo
    let ts = Int(Date().timeIntervalSince1970)
    let path = "/tmp/tradierlib_perf_\(ts).csv"
    do {
      try csv.joined(separator: "\n").appending("\n").write(
        toFile: path, atomically: true, encoding: .utf8,
      )
      csv.forEach { print($0) }
      print("Wrote CSV: \(path)")
    } catch {
      Issue.record("Failed to write CSV to \(path): \(error)")
    }
  }
}
