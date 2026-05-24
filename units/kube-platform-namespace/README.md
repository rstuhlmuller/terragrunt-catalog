# Kubernetes Platform Namespace Unit

This unit creates a shared `platform` namespace using the `kube-namespace-v1` module.

## Usage

```bash
terragrunt init
terragrunt plan
terragrunt apply
```

## Prerequisites

- Kubernetes provider configured through `KUBE_CONFIG_PATH` and optionally `KUBE_CTX`
- AWS KMS key for encrypted state
