/**
Keep this file focused — GitHub's own guidance notes Copilot is non-deterministic and that when "instructions are too numerous"
or "lack specificity," feedback quality degrades. Mirror the same content into an AGENTS.md at repo root
if you also use other agents (Copilot reads both; they merge at the repository tier).
*/
# Copilot Instructions — ACME Payments Platform (Spring Boot / Maven / Helm / AKS)

You are assisting on an enterprise Java 21 / Spring Boot microservices platform.
Build tool is Maven; we deploy via Helm charts to Azure Kubernetes Service (AKS);
CI/CD is GitLab CI. Follow these rules for ALL suggestions, chat and edits.

## Ask first — do not assume
- If requirements, IDs, field semantics, or the intended module are ambiguous,
  ASK clarifying questions before writing code. Do not invent business rules.
- Before large or cross-cutting changes, briefly state your plan, list the
  assumptions you are making, and surface trade-offs (performance, security,
  coupling). Wait for confirmation on anything that changes public APIs,
  database schemas, or Helm/infra.

## Architecture & layering
- Layered architecture: controller → service → repository. Controllers never call
  repositories directly. Domain logic lives in services, not controllers.
- Use constructor injection only. No field injection.
- DTOs at the boundary; never expose JPA entities from controllers.
- Respect existing package-by-feature structure; do not introduce new top-level
  packages without asking.

## Dependencies (avoid hallucinated/slopsquatted packages)
- Only use libraries already present in the parent POM / BOM. Do NOT add new
  dependencies unless explicitly asked. If a new dependency is truly needed,
  propose the exact Maven coordinates and STOP for approval — do not assume a
  group/artifact exists. All artifacts must resolve from our internal Nexus mirror.

## Resilience (required for every outbound call — maps to our SLOs)
- Every remote/HTTP/DB-adjacent call MUST have an explicit timeout.
- Outbound integrations MUST use Resilience4j: @TimeLimiter + @Retry, and
  @CircuitBreaker for third-party dependencies; add @RateLimiter where documented.
- Never swallow exceptions; log with correlation IDs; propagate typed failures.

## Security (GenAI chose the insecure option 45% of the time — Veracode 2025)
- NEVER hardcode secrets, tokens, connection strings or keys. Use Spring config +
  environment/Key Vault. Reject any suggestion that embeds a credential.
- Validate and sanitize ALL external input (Bean Validation / explicit checks).
- Enforce authn/authz on every endpoint; default-deny. State the authz rule you
  assumed. Use parameterized queries only. Encode output to prevent XSS/log injection.

## Tests (no happy-path-only)
- For every change, add/extend tests covering: happy path, boundary/edge values,
  null/empty, invalid input, and failure paths (timeouts, exceptions, retries).
- Tests must assert behavior and outputs, not merely execute code. Assume mutation
  testing (PITest) runs in CI — write tests that would kill mutants.
- Use JUnit 5 + AssertJ + Mockito; Testcontainers for integration where present.

## Style & simplicity (fight AI slop)
- Match existing code style (Spotless / google-java-format enforced in CI).
- Prefer the smallest correct change. Reuse existing helpers instead of copy/paste.
- No dead code, no speculative abstractions, no verbose boilerplate.

## Output discipline
- Explain non-obvious decisions in 1–3 lines. Flag anything you are unsure about.
- If you cannot verify an API exists, say so instead of inventing it.
