# Kubernetes Secret v1 Module

This module manages a `kubernetes_secret_v1` resource with OpenTofu state encryption.

## Usage

```hcl
module "registry_secret" {
  source = "./modules/kube-secret-v1"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  name       = "registry-auth"
  namespace  = "platform"
  type       = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "registry.example.com" = {
          username = "ci"
          password = "example"
        }
      }
    })
  }
}
```

## Notes

- Kubernetes Secret values are sensitive, but traditional `data` and `binary_data` values are still stored in Terraform state. Keep state encryption enabled.
- Use `data_wo` and `binary_data_wo` with matching revision variables when your provider version supports write-only secret values.
