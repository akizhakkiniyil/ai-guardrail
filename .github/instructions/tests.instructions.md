---
description: 'Test quality rules — no happy-path-only'
applyTo: '**/*Test.java,**/*Tests.java,**/*IT.java'
---
# Test rules
- Every behavior gets: happy path, edge/boundary, null/empty, invalid input,
  and failure path (timeout, exception, retry exhausted).
- Assert outcomes and side effects with AssertJ; avoid assertion-free tests.
- Name tests should_expectedBehavior_when_condition.
- Cover Resilience4j fallbacks and timeout behavior for outbound calls.
- Aim to kill PITest mutants: test boundaries (>, >=), negations, and returns.
