---
description: 'Helm chart rules for AKS deployment'
applyTo: 'helm/**,charts/**/*.yaml,charts/**/*.tpl'
---
# Helm / AKS rules
- Never hardcode secrets in values.yaml — reference Kubernetes Secrets / Key Vault CSI.
- Set resources.requests and resources.limits on every container.
- Define liveness and readiness probes; set terminationGracePeriodSeconds.
- Pin image tags by digest where possible; no :latest.
- Include PodDisruptionBudget and sensible replicaCount for HA.
- Charts must pass `helm lint` and kubeconform/kubeval in CI.
