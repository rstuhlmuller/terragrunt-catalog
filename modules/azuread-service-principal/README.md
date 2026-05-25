# AzureAD Service Principal Module

This module manages an `azuread_service_principal` associated with an AzureAD application registration.

## Usage

```hcl
module "argocd_enterprise_app" {
  source = "./modules/azuread-service-principal"

  kms_key_id = "alias/platform-opentofu"
  client_id  = module.argocd_oidc.client_id

  app_role_assignment_required = false

  feature_tags = {
    enterprise = true
  }
}
```

## Notes

- Set `use_existing = true` when managing a service principal that may already exist for the linked application.
- `tags` and `feature_tags` are mutually exclusive in the AzureAD provider, and this module enforces that relationship with a precondition.
