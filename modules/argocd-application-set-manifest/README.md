# Argo CD ApplicationSet Manifest Module

This module manages an Argo CD `ApplicationSet` CRD through `kubernetes_manifest`.

ApplicationSet has a large and fast-moving API surface. This module intentionally accepts the complete `spec` as an object so Terragrunt can control every generator, template, sync policy, and strategy field supported by your installed Argo CD version.

## Usage

```hcl
module "guestbook_appset" {
  source = "./modules/argocd-application-set-manifest"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  name       = "guestbook-envs"
  namespace  = "argocd"

  spec = {
    generators = [
      {
        list = {
          elements = [
            {
              cluster = "dev"
              url     = "https://kubernetes.default.svc"
            }
          ]
        }
      }
    ]
    template = {
      metadata = {
        name = "{{cluster}}-guestbook"
      }
      spec = {
        project = "default"
        source = {
          repoURL        = "https://github.com/argoproj/argocd-example-apps.git"
          path           = "guestbook"
          targetRevision = "HEAD"
        }
        destination = {
          server    = "{{url}}"
          namespace = "guestbook"
        }
      }
    }
  }
}
```
