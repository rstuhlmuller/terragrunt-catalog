# Kubernetes ConfigMap v1 Module

This module manages a `kubernetes_config_map_v1` resource with OpenTofu state encryption.

## Usage

```hcl
module "app_config" {
  source = "./modules/kube-config-map-v1"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  name       = "app-config"
  namespace  = "platform"

  data = {
    LOG_LEVEL = "info"
  }
}
```
