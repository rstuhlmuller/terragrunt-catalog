# AzureAD Application Password Module

This module manages an `azuread_application_password` for an existing AzureAD application registration.

## Usage

```hcl
module "argocd_oidc_password" {
  source = "./modules/azuread-application-password"

  kms_key_id        = "alias/platform-opentofu"
  application_id    = module.argocd_oidc.id
  display_name      = "argocd-oidc"
  end_date_relative = "8760h"

  rotate_when_changed = {
    rotation = "2026-01"
  }
}
```

## Notes

- The generated password value is sensitive but still stored in state. Keep OpenTofu state encryption enabled.
- Change `rotate_when_changed` to intentionally rotate the password.
