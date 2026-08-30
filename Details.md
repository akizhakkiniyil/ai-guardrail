CODEOWNERS
# Mandatory human review; AI-heavy areas get senior/security owners.
*                       @acme/tech-leads
/src/main/java/**/security/**   @acme/appsec
/helm/**                @acme/platform
/.gitlab-ci.yml         @acme/platform @acme/appsec
/pom.xml                @acme/tech-leads   # dependency changes need lead sign-off
Commit trailer convention (git)

Adopt the emerging RAI footer convention so provenance is machine-readable via git log --grep / git interpret-trailers. The Assisted-by: trailer for AI-assisted (human-authored) contributions and Co-authored-by: for substantial AI contribution have both emerged as open-source conventions; Signed-off-by: keeps a named human accountable:

Assisted-by: Copilot            # AI helped (suggestions)
Co-authored-by: Copilot <copilot@github.com>   # substantial AI contribution
Signed-off-by: Jane Doe <jane@acme.com>        # human takes responsibility
Pitfall → Control Mapping
#	Pitfall	Primary control(s) / file(s)	Type
1	Security flaws (GenAI chose insecure 45% of the time)	copilot-instructions security section; Semgrep + GitLab SAST; SpotBugs/FindSecBugs; gitleaks/Secret-Detection; /threat-model-this-change; CODEOWNERS appsec	Preventive + Detective
2	Hallucinated APIs	MCP api-specs + context7 server; copilot-instructions "don't invent APIs"; /review-ai-code; compilation + tests in CI	Preventive + Detective
3	Context blindness	copilot-instructions (architecture/business rules); path-scoped instructions; internal MCP context; ArchUnit	Preventive
4	Architectural misfit (no retries/timeouts)	ArchUnit resilience-annotation rule; Semgrep require-timeouts; Resilience4j; helm probes/limits rules	Preventive + Detective
5	AI slop / tech debt	Spotless + google-java-format; Checkstyle; Error Prone; copilot "smallest change" rule; GitClear churn metrics	Preventive + Detective
6	Weak tests (happy-path only)	PITest mutation gate; JaCoCo; tests.instructions.md; /write-edge-case-tests	Detective + Preventive
7	Skipped gates	GitLab CI as source of truth; pre-commit; gitlab-ci.instructions "never disable a gate"; branch protection	Detective/Corrective
8	Performance regressions	k6 perf-smoke gate; JMH for hot paths; SpotBugs perf patterns	Detective
9	Skill atrophy	Process: explain-before-accept ritual; /explain-this-before-i-accept; AI-free rotations; DORA metrics	Corrective (process)
10	Feedback-free loops	Process: DORA + rework/churn tracking; MR template evidence; no feature merges without tests/telemetry	Corrective (process)
11	Knowledge dilution	CODEOWNERS review; MR "I can explain every line" checkbox; provenance trailers; ArchUnit as living docs	Corrective (process + tooling)
12	Idle assumptions	copilot-instructions "ask first / surface trade-offs"; askQuestions in prompts; MR review	Preventive
13	Context mismatches	MCP repo/API context; path-scoped instructions; copilot-instructions module rules	Preventive
14	Over-automation in IDEs	.vscode/settings.json autoApprove deny-lists; chat.tools.global.autoApprove:false; chat.mcp.autoStart:never	Preventive
What tooling CANNOT solve (and the process answers)

Five pitfalls are fundamentally human/organizational — gates help but cannot fix them:

Skill atrophy (9): The METR 2025 RCT (arXiv:2507.09089) showed experienced developers took 19% longer with AI ("allowing AI actually increases completion time by 19%") yet estimated afterward that it had sped them up by 20% — false confidence is the real risk. Countermeasures: an "explain-before-accept" ritual (a developer must be able to explain any accepted AI code, backed by the /explain-this-before-i-accept prompt); rotating AI-free debugging exercises (e.g., one AI-free sprint task per dev per iteration); pairing juniors with seniors on AI-generated diffs.
Feedback-free loops (10): Easy generation encourages feature spam. Countermeasure: gate merges on tests + telemetry, and track DORA metrics (deploy frequency, lead time, change-fail rate, MTTR) plus rework rate. If change-fail rate or rework rises with AI adoption, that is your signal.
Knowledge dilution (11): GitClear found copy/paste exceeded refactoring in 2024 and an 8-fold rise in duplicated code blocks (≥5 lines) — partially-understood AI code accretes. Countermeasures: CODEOWNERS-enforced review, the "I can explain every line" MR checkbox, provenance trailers so you can git blame AI-heavy regions, and treating duplicate-block metrics as a health KPI.
Idle assumptions (12) & over-automation (14): Instructions and settings reduce these but a disciplined review norm ("no silent large diffs; agent changes require explicit confirmation") is the real control.

Metrics to track from day one: DORA four keys; code churn / rework rate — GitClear measured churn (lines reverted/rewritten within two weeks) rising from a pre-AI 2021 baseline of 3.3% to 5.7% in 2024 and 7.1% in 2025, so use ~3–4% as your "healthy" reference and watch the trend after adoption; duplicate-block count; mutation score trend; % MRs with AI disclosure; escaped-defect rate. Measure, don't assume — because the perceived-vs-actual productivity gap is the headline empirical finding.

Rollout Plan

Week 1 (pilot repo only):

Stand up the golden image + devcontainer.json; get 2–3 volunteers running it in both VS Code and IntelliJ via DevPod. Validate the JetBrains plugin fallback works.
Commit copilot-instructions.md, one or two instructions files, and the .vscode/settings.json autoApprove hardening.
Turn on local pre-commit (gitleaks, Spotless, hallucinated-dep check).

Month 1 (harden the pilot):

Add the full GitLab CI gate set, but start most quality gates as non-blocking (warn) to establish baselines; make secrets + SAST blocking immediately.
Introduce PITest and JaCoCo at current baseline thresholds (don't demand 85% on day one — the recommended pattern is to start at or slightly below the current score, prevent regression, then ratchet).
Add the ArchUnit layering test; add the Semgrep custom timeout rule.
Stand up the internal API-spec MCP server; point Maven at the Nexus mirror.
Begin the explain-before-accept ritual and start capturing DORA + churn baselines.

Quarter 1 (org-wide):

Promote gates from warn → block once baselines are stable (target mutation ≥70%, coverage ≥80%).
Roll the golden image + artefacts to all Spring Boot repos via a template repo.
Enable Copilot Business/Enterprise content exclusion at the org level (keyed to GitLab remote URLs) for secret-bearing paths.
Institute a quarterly golden-image refresh and a metrics review; run the first AI-free debugging rotation.

Ratchet thresholds: raise the mutation threshold in steps (70→80→85 for critical modules); tighten k6 perf thresholds once a stable baseline exists. Roll back a gate to warn only if it produces sustained false positives, and fix the rule rather than disabling it.

Caveats (honest)
GitLab, not GitHub, breaks several Copilot features. IDE-side artefacts (copilot-instructions.md, instructions files, prompt files, chat modes, AGENTS.md, MCP, autoApprove settings) work from local files regardless of remote — GitHub's cloud-agent docs even state the cloud agent "only works with repositories hosted on GitHub," confirming these features are host-bound while the IDE ones are not. But Copilot code review (the PR reviewer), the Copilot cloud/coding agent, .github/workflows/copilot-setup-steps.yml, and the coding-agent firewall are GitHub-hosted-repo + GitHub Actions features and will NOT work for GitLab-hosted repos. Content exclusion is a GitHub org/enterprise setting but can target GitLab repos by git-remote URL (Business/Enterprise plan) — though the docs state it is "currently not supported in Edit and Agent modes of Copilot Chat" or the CLI. Net: your automated-review backstop must be GitLab CI + human MR review, not Copilot code review.
JetBrains Copilot lags VS Code. copilot-instructions.md works in IntelliJ; but prompt files (/name) are documented as not yet auto-loading in the JetBrains plugin (community discussion 
#171759, and gated behind editor_preview_features), chat modes/custom agents reached JetBrains GA only in March 2026, and MCP tool context is not passed to Copilot Chat in JetBrains (discussion 
#194295). Treat VS Code as the reference IDE for the full artefact set, document the IntelliJ gaps, and rely on CI for anything JetBrains cannot enforce.
Licensing/tiers: Copilot content exclusion and knowledge bases require Copilot Business/Enterprise; GitLab Dependency Scanning/DAST require Ultimate, and secret-detection push rules require Premium. Context7 MCP needs an API key. Verify before depending on any of these.
Maintenance burden: the golden image is a living asset — someone owns digest updates, CVE patching, feature-version bumps and the lockfile. Budget for a quarterly refresh cadence and a break-glass process when a pinned tool has a critical CVE.
Auto-approve settings are marked Experimental in current VS Code docs and can change between releases — re-verify the setting keys after Copilot/VS Code upgrades.
Provenance trailers are advisory, not proof. Developers can strip or spoof them (as the May 2026 VS Code "Co-authored-by" default-on backlash showed); treat them as audit-assist, and back high-assurance needs with signed commits and CI logs.
Package-hallucination rates are improving but not gone: a 2026 replication (arXiv:2605.17062) of the USENIX methodology on five frontier models found rates "between 4.62% (Claude Haiku 4.5) and 6.10% (GPT-5.4-mini)—an order-of-magnitude compression" from the earlier 5.2–21.7% spread, so the Nexus-mirror + existence-check defense remains necessary but the residual risk is lower than in 2025.
Conflicting productivity signals exist: GitClear and METR point to slowdowns/quality erosion, while Google's DORA has reported small AI-linked quality gains alongside a delivery-stability reduction — reinforcing that you should instrument your own metrics rather than trust any single external number.
