# Argo CD Repository Module

This module manages an `argocd_repository` resource with OpenTofu state encryption.

## Usage

```hcl
module "apps_repo" {
  source = "./modules/argocd-repository"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  repo       = "https://github.com/example/platform-apps.git"
  type       = "git"
  project    = "platform"
}
```

## Private GitHub App Repository

```hcl
module "private_repo" {
  source = "./modules/argocd-repository"

  kms_key_id                    = "arn:aws:kms:us-east-1:123456789012:key/example"
  repo                          = "https://github.com/example/private-apps.git"
  type                          = "git"
  githubapp_id                  = "123456"
  githubapp_installation_id     = "987654"
  githubapp_private_key         = var.githubapp_private_key
  githubapp_enterprise_base_url = null
}
```

## Notes

- Repository credentials are marked sensitive and should remain protected by encrypted state.
- Use `project` for project-scoped repositories when Argo CD project isolation is enabled.
