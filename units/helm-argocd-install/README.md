# Helm Argo CD Install Unit

This unit installs Argo CD using the `helm-release` module.

## Usage

```bash
terragrunt init
terragrunt plan
terragrunt apply
```

## Configuration

Edit `terragrunt.hcl` to pin a chart version, change service settings, or add chart values for your cluster.

## Prerequisites

- Kubernetes provider configured through `KUBE_CONFIG_PATH` and optionally `KUBE_CTX`
- AWS KMS key for encrypted state
