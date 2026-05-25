# AWS SSM Parameters Module

This module manages AWS Systems Manager SecureString parameters, optional KMS key creation, and an optional IAM reader group for workloads that need to read those parameters.

It is based on the homelab SSM parameter module and keeps placeholder values ignored after creation so real secret values can be filled or rotated outside Terraform without being overwritten.

## Usage

```hcl
module "runtime_parameters" {
  source = "./modules/aws-ssm-parameters"

  kms_key_id   = "alias/platform-opentofu"
  kms_region   = "us-west-2"
  aws_region   = "us-west-2"
  project_name = "platform"

  create_kms_key = false

  parameter_reader_iam_user_names = [
    "external-secrets_aws-ssm-auth",
  ]

  parameters = {
    "/platform/app/client-id" = {
      description   = "OIDC client ID issued by the identity provider."
      initial_value = "REPLACE_ME"
    }

    "/platform/app/client-secret" = {
      description   = "OIDC client secret issued by the identity provider."
      initial_value = "REPLACE_ME"
    }
  }
}
```

## Notes

- `kms_key_id` is still the catalog-wide OpenTofu state encryption key input. Set `parameter_kms_key_id` only when SSM SecureStrings should use a different key.
- When `create_kms_key` is true, `parameter_kms_key_id` or `kms_key_id` must be an `alias/...` name because the module creates an `aws_kms_alias`.
- SSM parameter `value` changes are ignored after creation by design. Replace placeholder values directly in Parameter Store or through a separate rotation process.
