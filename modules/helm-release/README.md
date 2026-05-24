# Helm Release Module

This module manages a single `helm_release` with OpenTofu state encryption using AWS KMS.

## Features

- Chart installs from repositories, local paths, chart archives, and OCI repositories
- Full release lifecycle controls such as `atomic`, `wait`, `timeout`, `replace`, and `take_ownership`
- Helm value controls through `values`, `set`, `set_list`, `set_sensitive`, and write-only `set_wo`
- Optional post-render command support
- OpenTofu state and plan encryption with AWS KMS

## Usage

```hcl
module "argocd" {
  source = "./modules/helm-release"

  kms_key_id       = "arn:aws:kms:us-east-1:123456789012:key/example"
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  chart_version    = "pin-your-chart-version"

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]

  set = [
    {
      name  = "server.service.type"
      value = "ClusterIP"
      type  = "string"
    }
  ]
}
```

## Notes

- Repository credentials and sensitive Helm values are marked sensitive, but state encryption is still important because rendered release data can contain sensitive content.
- `set_wo` requires a provider version that supports write-only values. Increment `set_wo_revision` when those values should be updated.
