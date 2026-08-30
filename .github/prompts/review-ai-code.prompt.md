---
description: 'Adversarial self-review of AI-generated changes'
mode: 'agent'
tools: ['search/codebase', 'editFiles']
---
Review the current diff as a skeptical senior engineer. For each changed file:
1. List assumptions the code makes and whether they are verified in this repo.
2. Flag any invented/unverified APIs or dependencies not in the parent POM.
3. Check: input validation, authz, no hardcoded secrets, parameterized queries.
4. Check: every outbound call has a timeout + Resilience4j annotations.
5. Identify missing edge-case/failure-path tests.
6. Rate slop risk (duplication, dead code, needless abstraction) and suggest the
   smaller change.
Output a checklist with PASS/FAIL and concrete fixes. Do not edit yet.
