# Argo CD Application Manifest Module

This module manages an Argo CD `Application` CRD through `kubernetes_manifest`.

Use this module when you need exact control over the Application manifest or a field/version that is not exposed by the typed `argocd_application` provider resource yet.

## Usage

```hcl
module "guestbook_application" {
  source = "./modules/argocd-application-manifest"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  name       = "guestbook"
  namespace  = "argocd"

  finalizers = [
    "resources-finalizer.argocd.argoproj.io"
  ]

  spec = {
    project = "default"
    source = {
      repoURL        = "https://github.com/argoproj/argocd-example-apps.git"
      path           = "guestbook"
      targetRevision = "HEAD"
    }
    destination = {
      server    = "https://kubernetes.default.svc"
      namespace = "guestbook"
    }
    syncPolicy = {
      automated = {
        prune    = true
        selfHeal = true
      }
      syncOptions = [
        "CreateNamespace=true"
      ]
    }
  }
}
```

## Notes

- This module uses Kubernetes CRD field names, such as `repoURL` and `syncPolicy`, rather than Terraform provider field names.
- The Argo CD Application CRD must be installed before planning this resource.
