# Kubernetes Namespace v1 Module

This module manages a `kubernetes_namespace_v1` resource with OpenTofu state encryption.

## Usage

```hcl
module "platform_namespace" {
  source = "./modules/kube-namespace-v1"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  name       = "platform"

  labels = {
    "app.kubernetes.io/managed-by" = "terragrunt"
  }
}
```
