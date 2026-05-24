# Argo CD Project Module

This module manages an `argocd_project` resource with OpenTofu state encryption.

## Usage

```hcl
module "platform_project" {
  source = "./modules/argocd-project"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"

  metadata = {
    name      = "platform"
    namespace = "argocd"
  }

  description       = "Platform-owned applications"
  source_namespaces = ["argocd"]
  source_repos      = ["https://github.com/example/platform-apps.git"]

  destinations = [
    {
      server    = "https://kubernetes.default.svc"
      namespace = "platform"
    }
  ]

  namespace_resource_whitelist = [
    {
      group = "*"
      kind  = "*"
    }
  ]
}
```

## Notes

- Role JWT lifecycle is intentionally handled outside this module by Argo CD token resources.
- Use explicit `source_repos`, `destinations`, and resource allow lists in production.
