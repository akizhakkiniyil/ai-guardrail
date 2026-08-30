---
description: 'Generate failure-path and boundary tests'
mode: 'agent'
tools: ['search/codebase', 'editFiles']
---
For the selected class, generate JUnit 5 + AssertJ + Mockito tests that cover:
boundary values, null/empty, invalid input, and failure paths (timeout,
exception, retry exhaustion, circuit open). Assert outcomes, not just execution.
Write tests designed to kill PITest mutants (conditionals, negations, returns).
Ask me for any unclear business rule before generating.
