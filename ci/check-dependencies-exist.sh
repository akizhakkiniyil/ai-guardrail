#!/usr/bin/env bash
# Fail if any declared Maven dependency cannot be resolved from the internal
# mirror. Because the mirror only proxies vetted artifacts, hallucinated/
# slopsquatted coordinates 404 here — before they ever reach a build agent.
set -euo pipefail
echo "==> Verifying all declared dependencies resolve from internal mirror"
mvn -q -B -o dependency:resolve -DincludeScope=runtime 2>/dev/null \
  || { echo "Offline resolve failed; forcing online resolve against mirror"; \
       mvn -q -B dependency:resolve -DincludeScope=runtime; }
echo "All dependencies resolved from approved mirror."
