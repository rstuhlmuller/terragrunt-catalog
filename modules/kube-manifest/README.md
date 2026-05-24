# Kubernetes Manifest Module

This module manages any Kubernetes resource through `kubernetes_manifest`.

## Use Cases

- CRDs and custom resources
- New Kubernetes API versions before typed provider resources are available
- Argo CD resources where the CRD schema has fields that the typed Argo CD provider does not expose yet

## Usage

```hcl
module "manifest" {
  source = "./modules/kube-manifest"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"

  manifest = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "app-config"
      namespace = "default"
    }
    data = {
      LOG_LEVEL = "info"
    }
  }

  field_manager = {
    name            = "terragrunt-catalog"
    force_conflicts = true
  }
}
```

## Notes

- The Kubernetes API server must be reachable at plan time because the provider validates the manifest schema during planning.
- Install CRDs before creating custom resources that depend on them.
- Use `computed_fields` for fields changed by admission controllers.
