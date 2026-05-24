# Argo CD Guestbook App Unit

This unit creates the Argo CD example guestbook application using the typed `argocd-application` module.

## Usage

```bash
terragrunt init
terragrunt plan
terragrunt apply
```

## Prerequisites

- Argo CD installed and reachable by the Argo CD provider
- Argo CD provider credentials configured through supported `ARGOCD_*` environment variables or local Argo CD config
- AWS KMS key for encrypted state

## Exact CRD Control

If your Application needs a field that the typed provider does not expose, switch the unit source to `../../modules/argocd-application-manifest` and pass the complete CRD `spec` object.
