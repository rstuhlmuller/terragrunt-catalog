# Kubernetes Secret From SSM Module

This module reads encrypted AWS Systems Manager parameters and creates a `kubernetes_secret_v1` from their decrypted values.

## Usage

```hcl
module "external_secrets_aws_auth" {
  source = "./modules/kubernetes-secret-from-ssm"

  kms_key_id = "alias/platform-opentofu"
  name       = "aws-ssm-auth"
  namespace  = "external-secrets"

  labels = {
    "app.kubernetes.io/managed-by" = "terragrunt"
    "app.kubernetes.io/name"       = "aws-ssm-auth"
  }

  data_ssm_parameter_names = {
    "access-key-id"     = "/platform/external-secrets/aws-ssm/access-key-id"
    "secret-access-key" = "/platform/external-secrets/aws-ssm/secret-access-key"
  }
}
```

## Notes

- The module fails before creating the Secret if any referenced SSM value is empty or still set to `placeholder_value`.
- Decrypted values are written into Terraform state as Kubernetes Secret data. Keep OpenTofu state encryption enabled.
