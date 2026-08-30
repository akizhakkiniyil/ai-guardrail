## What & why

## AI-usage disclosure (required)
- [ ] This MR contains AI-assisted code (Copilot).
- [ ] Every AI-assisted commit carries an `Assisted-by:` / `Co-authored-by:` trailer.
- [ ] I have personally read and can explain every AI-generated line.
- [ ] No hallucinated/unverified APIs or dependencies (all resolve from Nexus).
- [ ] Outbound calls have timeouts + Resilience4j annotations.
- [ ] Tests cover edge cases and failure paths (not just happy path).
- [ ] No hardcoded secrets; input validated; authz enforced.
- [ ] Ran `/review-ai-code` and `/threat-model-this-change` on this diff.

## Testing evidence

## Gates
- [ ] Spotless/Checkstyle/ArchUnit green
- [ ] Coverage ≥ 80%, mutation ≥ 70%
- [ ] SAST / secret / dependency / container scans clean
