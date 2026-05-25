# AzureAD Application Module

This module manages an AzureAD application registration with OpenTofu state encryption.

## Usage

```hcl
module "argocd_oidc" {
  source = "./modules/azuread-application"

  kms_key_id             = "alias/platform-opentofu"
  display_name           = "argocd-homelab"
  prevent_duplicate_names = true

  web = {
    homepage_url  = "https://argocd.example.com"
    redirect_uris = ["https://argocd.example.com/auth/callback"]
  }

  group_membership_claims = ["SecurityGroup"]

  optional_claims = {
    id_tokens = [
      {
        name = "groups"
      }
    ]
  }
}
```

## Notes

- Use `azuread-application-password` when password rotation should be managed separately from the application lifecycle.
- `tags` and `feature_tags` are mutually exclusive in the AzureAD provider, and this module enforces that relationship with a precondition.
- Inline password values are sensitive but still end up in state. Keep OpenTofu state encryption enabled.
