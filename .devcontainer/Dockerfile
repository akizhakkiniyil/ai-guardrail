# Pin base by digest. Update deliberately via the golden-image pipeline.
FROM mcr.microsoft.com/devcontainers/java:1-21-bookworm@sha256:REPLACE_WITH_DIGEST

ARG MAVEN_VERSION=3.9.9
ARG USERNAME=vscode

# System tooling used by local gates
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        python3 python3-pip python3-venv pipx jq git curl unzip shellcheck \
    && rm -rf /var/lib/apt/lists/*

# pre-commit + semgrep pinned for reproducibility
RUN pipx install pre-commit==3.8.0 \
    && pipx install semgrep==1.90.0

# gitleaks (pinned)
RUN curl -sSL -o /tmp/gitleaks.tar.gz \
      https://github.com/gitleaks/gitleaks/releases/download/v8.21.2/gitleaks_8.21.2_linux_x64.tar.gz \
    && tar -xzf /tmp/gitleaks.tar.gz -C /usr/local/bin gitleaks \
    && rm /tmp/gitleaks.tar.gz

# Point Maven at the internal mirror (defense vs slopsquatting/dependency confusion)
COPY settings.xml /home/${USERNAME}/.m2/settings.xml
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.m2

USER ${USERNAME}
