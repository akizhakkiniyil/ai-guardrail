---
description: 'GitLab CI pipeline rules'
applyTo: '**/*.gitlab-ci.yml,.gitlab-ci.yml'
---
# GitLab CI rules
- Never disable or `allow_failure: true` a security or quality gate to make a
  pipeline pass. Ask a human instead.
- Keep the security template includes intact (SAST, Secret-Detection,
  Dependency-Scanning, Container-Scanning).
- Pin image tags used by jobs. Do not add pipeline steps that exfiltrate secrets.
