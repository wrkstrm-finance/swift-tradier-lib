import ArgumentParser
import Foundation
#if canImport(ReerJSONParserAdapter)
import ReerJSONParserAdapter
#endif
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalMain

// Benchmark JSON decoding throughput and emit CSV with metadata.
// Example:
//   tradier-json-perf-cli --dir Benchmarks/JSON --windows 25 --hz 144

struct TradierJSONPerfCLI: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "tradier-json-perf-cli",
    abstract: "Benchmark JSON decoding throughput (ops per frame budget).",
  )

  @ArgumentParser.Option(name: .long, help: "Directory of JSON payload files.")
  var dir: String = FileManager.default.currentDirectoryPath

  @ArgumentParser.Option(name: .long, help: "Number of sampling windows per payload.")
  var windows: Int = 25

  @ArgumentParser.Option(name: .long, help: "Target refresh rate (Hz). Budget = 1/Hz seconds.")
  var hz: Double = 144.0

  @ArgumentParser.Option(name: .long, help: "Output CSV path (default /tmp/json-perf_<ts>.csv)")
  var out: String?

  func run() async throws {
    func now() -> TimeInterval { Date().timeIntervalSinceReferenceDate }

    let budget = 1.0 / max(1.0, hz)
    let winCount = max(1, windows)

    let foundation = JSONDecoder.commonDateParsing
    #if canImport(ReerJSONParserAdapter)
    let reer = ReerJSONParserAdapter.makeParser()
    #endif

    struct Payload<T: Decodable> {
      let name: String
      let data: Data
      let type: T.Type
    }

    func load(path: String) throws -> Data { try Data(contentsOf: URL(fileURLWithPath: path)) }

    func detect(_ name: String, data: Data) -> Any? {
      switch true {
      case name.contains("user_profile"):
        Payload(name: name, data: data, type: Tradier.TradierBrokerageUserProfileRootModel.self)

      case name.contains("positions"):
        Payload(name: name, data: data, type: Tradier.TradierBrokeragePositionsRootModel.self)

      case name.contains("option_expirations"):
        Payload(name: name, data: data, type: Tradier.TradierBrokerageOptionExpirationsRootModel.self)

      case name.contains("quotes"):
        Payload(name: name, data: data, type: Tradier.TradierBrokerageSingleQuoteRootModel.self)

      case name.contains("option_chain"):
        Payload(name: name, data: data, type: Tradier.TradierBrokerageOptionChainRootModel.self)
      default: nil
      }
    }

    func median(_ values: [Double]) -> Double {
      let s = values.sorted()
      let m = s.count / 2
      return s.count % 2 == 0 ? (s[m - 1] + s[m]) / 2.0 : s[m]
    }
    func p95(_ values: [Double]) -> Double {
      let s = values.sorted()
      let i = Int(Double(s.count - 1) * 0.95)
      return s[max(0, min(i, s.count - 1))]
    }

    func runsWithinBudget(_ decode: () throws -> some Any) rethrows -> [Double] {
      var results: [Double] = []
      results.reserveCapacity(winCount)
      for _ in 0..<winCount {
        let start = now()
        var count = 0.0
        while (now() - start) < budget {
          _ = try decode()
          count += 1
        }
        results.append(count)
      }
      return results
    }

    // Discover payload files
    let fm = FileManager.default
    guard let entries = try? fm.contentsOfDirectory(atPath: dir) else {
      throw ValidationError("Cannot read directory: \(dir)")
    }
    var payloads: [Any] = []
    for e in entries where e.hasSuffix(".json") {
      let p = (dir as NSString).appendingPathComponent(e)
      guard let data = try? load(path: p) else { continue }
      if let pl = detect(e, data: data) { payloads.append(pl) }
    }

    // Metadata
    let host = Host.current().localizedName ?? "unknown-host"
    let ts = Int(Date().timeIntervalSince1970)
    let outPath = out ?? "/tmp/json-perf_\(ts).csv"
    var csv: [String] = [
      "# host=\(host)", "# hz=\(hz)", "# windows=\(winCount)", "payload,engine,mean,median,p95",
    ]

    func report<T>(_ pl: Payload<T>) {
      do {
        let fRuns = try runsWithinBudget { try foundation.decode(T.self, from: pl.data) }
        let fMean = fRuns.reduce(0, +) / Double(fRuns.count)
        csv.append(
          "\(pl.name),foundation,\(String(format: "%.2f", fMean)),\(String(format: "%.2f", median(fRuns))),\(String(format: "%.2f", p95(fRuns)))",
        )

        #if canImport(ReerJSONParserAdapter)
        let rRuns = try runsWithinBudget { try reer.decode(T.self, from: pl.data) }
        let rMean = rRuns.reduce(0, +) / Double(rRuns.count)
        csv.append(
          "\(pl.name),reerjson,\(String(format: "%.2f", rMean)),\(String(format: "%.2f", median(rRuns))),\(String(format: "%.2f", p95(rRuns)))",
        )
        #endif
      } catch {
        FileHandle.standardError.write(
          Data("warn: failed on payload \(pl.name): \(error)\n".utf8)
        )
      }
    }

    for anyP in payloads {
      if let p = anyP as? Payload<Tradier.TradierBrokerageUserProfileRootModel> {
        report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokeragePositionsRootModel> {
        report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokerageOptionExpirationsRootModel> {
        report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokerageSingleQuoteRootModel> {
        report(p)
      } else if let p = anyP as? Payload<Tradier.TradierBrokerageOptionChainRootModel> {
        report(p)
      }
    }

    do {
      try csv.joined(separator: "\n").appending("\n").write(
        toFile: outPath, atomically: true, encoding: .utf8,
      )
      print("Wrote CSV: \(outPath)")
    } catch {
      throw ValidationError("Failed writing CSV: \(error)")
    }
  }
}

// Entry point
TradierJSONPerfCLI.main()
