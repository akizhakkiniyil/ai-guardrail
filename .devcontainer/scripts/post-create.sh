#!/usr/bin/env bash
set -euo pipefail

echo "==> Verifying toolchain versions"
java -version
mvn -version | head -1
kubectl version --client=true -o yaml | grep gitVersion | head -1 || true
helm version --short || true
az version -o table 2>/dev/null | head -3 || true

EXPECTED_JAVA="21"
if ! java -version 2>&1 | grep -q "\"${EXPECTED_JAVA}"; then
  echo "WARNING: expected Java ${EXPECTED_JAVA}. Golden image drift?" >&2
fi

echo "==> Installing git hooks via pre-commit"
pre-commit install --install-hooks
pre-commit install --hook-type commit-msg

echo "==> Warming Maven dependency cache from internal mirror"
mvn -q -B -DskipTests dependency:go-offline || true

echo "==> Wiring SonarLint connected mode (uses SONAR_HOST_URL from env)"
mkdir -p .vscode
# .sonarlint connected-mode binding is committed at repo root (see .sonarlint/)

echo "==> JetBrains fallback plugin install (DevPod issue #1153 workaround)"
RD="$HOME/.cache/JetBrains/RemoteDev/dist"
if [ -d "$RD" ]; then
  SERVER=$(find "$RD" -name remote-dev-server.sh | head -1 || true)
  if [ -n "${SERVER:-}" ]; then
    "$SERVER" installPlugins "$PWD" com.github.copilot org.sonarlint.idea || true
  fi
fi

echo "==> Bootstrap complete"
