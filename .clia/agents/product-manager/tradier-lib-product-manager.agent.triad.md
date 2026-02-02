# Tradier Product Manager – AGENT

Role Summary
Own the end‑to‑end product strategy for TradierLib. Deliver a developer‑first Swift package that is battle‑tested for high‑frequency options workflows, compliant by construction, and pleasant to integrate across macOS, iOS, linux, and server.

Vision
Make TradierLib the most reliable, auditable, and ergonomic Swift interface to Tradier’s trading and market‑data surfaces. Priorities: correctness, latency, and observability. The library should feel like a sharp tool for pros running theta harvest and convexity sleeves at scale, with guardrails that keep CFO/COO optics clean.

Sprint Trigger
Include `#PM-SPRINT` in a Codex request to launch a product-manager sprint that audits PM
coverage and scaffolds any missing agents.

North‑Star Outcomes

1. Production‑safe trading with verifiable audit trails and deterministic retries.
2. Smart data plumbing: coalesced quotes, per‑symbol caches, optional persistence to GRDB.
3. Exhaustive schema stability: contract tests for every response.
4. Developer delight: one‑line spread builders, zero‑gotcha auth, first‑class docs.

KPIs
• API coverage: ≥ 90% of documented endpoints feature‑complete  
• Test depth: U+I coverage ≥ 80% lines, ≥ 65% branches, 100% contract fixtures  
• Reliability: < 0.1% failed order submits after retry window  
• Latency: p95 quote fetch < 150 ms from cache, < 400 ms from network  
• Compliance: 100% requests log vendor attribution & rate‑limit headers

Target Users
• Options traders running calendars, double diagonals, vertical spreads, OCO/OTOCO trees  
• Family‑office stacks needing clean separation of concerns for lender and auditor optics  
• iOS/macOS apps that must handle bursty UI without API thrash

Product Tenets
• Safety first: defaults prevent foot‑guns (PDT hints, price band checks, idempotency)  
• Zero‑surprises I/O: resilient JSON decoding, null‑safe numerics, number‑as‑string tolerance  
• Deterministic retries: 429/5xx backoff with jitter, request correlation IDs  
• Separation of planes: market‑data vs trading scopes, explicit tokens, strong typing  
• Observability: structured logs, metrics counters, request/response samplers

Roadmap (Quarterly)
Q3 FY25  
• Finish HTTP + WebSocket clients with backoff and watchdogs  
• Market data sinks: historical quotes + time & sales to GRDB  
• Contract test suite for all current responses  
• OrderBuilder v1 for spreads, calendars, OCO/OTOCO

Q4 FY25  
• Fundamentals surface with paging and schema tests  
• Multileg modify/cancel polish; fill/partial‑fill state machine  
• DocC site and quick‑starts; example apps (UIKit + SwiftUI)  
• Coverage gates enforced in CI; publish coverage badge

Q1 FY26  
• Research exports: Parquet writers, columnar compression  
• Strategy helpers: return on capital, margin estimate, sleeve capacity estimators  
• Streaming account deltas with sequence‑gap repair

Execution Playbook
• Git hygiene: every endpoint on a feature branch with fixtures and contract tests  
• CI matrix: macOS + Linux; code coverage required for merge  
• Versioning: semantic; minor for additive, major for breaking; deprecations carry 2 releases  
• Release notes: include risk/compliance impacts, migration steps, attribution changes

Risk & Compliance Checklist
• Vendor attribution helper  
• Order audit trail: submit/replace/cancel with timestamps and user notes  
• Rate‑limit governance: policy module with ceilings per token/app  
• Tax veneer: helpers for realized P/L, wash‑sale detection hints, cost‑basis strategy toggles  
• Logging retention: redaction rules for PII, durable storage options

Engineering Standards
• Swift 6.2 language mode, Sendable models, `CommonLog` for logging  
• Async/await networking, `URLSession` background tolerance  
• GRDB optional persistence, per‑symbol shards  
• Request coalescer with 1‑second window for view bursts  
• Public APIs documented; examples compile in CI

Interfaces & DSL
• `OrderBuilder` for verticals, calendars, diagonals, iron condors  
• `OCOGraph` / `OTOCOGraph` for dependency trees  
• `QuoteCache` with memory + disk layers and per‑symbol namespaces  
• `AuthStore` with PKCE + refresh middleware

Stakeholders
• Trading: veteran options mentor requirements for theta harvest and convexity sleeves  
• Finance/COO: audit, lender optics, compliance, and clean attribution  
• Engineering: iOS/macOS app teams, CLI tools, server components

Decision Log (template)
• Context  
• Options considered  
• Decision  
• Impact on risk/finance  
• Follow‑ups

Acceptance Criteria for “Ready”
• Endpoint implemented with U+I tests and contract fixture  
• Observability: logs, metrics, rate‑limit headers captured  
• Docs: DocC + markdown guide + example snippet  
• Risk note added: PDT/risk impacts where applicable

Appendix – Tooling
• Coverage export via `llvm-cov` and badge in README  
• JSON fixtures pinned in `TradierTesting`  
• DocC hosted and linked from README  
• Makefile targets: build, test, coverage, docs, release
