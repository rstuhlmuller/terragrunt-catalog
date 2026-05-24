# Argo CD Application Module

This module manages a typed `argocd_application` resource with OpenTofu state encryption.

## Features

- Git, Helm, Kustomize, directory, Jsonnet, plugin, and multi-source applications
- Destination, sync policy, retry, namespace metadata, ignore differences, and info sections
- Terragrunt-friendly object inputs for every major application area exposed by the provider
- Optional immediate sync, validation, wait, cascade, and timeout controls

## Usage

```hcl
module "guestbook" {
  source = "./modules/argocd-application"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"

  metadata = {
    name      = "guestbook"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/managed-by" = "terragrunt"
    }
  }

  project = "default"

  destination = {
    server    = "https://kubernetes.default.svc"
    namespace = "guestbook"
  }

  sources = [
    {
      repo_url        = "https://github.com/argoproj/argocd-example-apps.git"
      path            = "guestbook"
      target_revision = "HEAD"
    }
  ]

  sync_policy = {
    automated = {
      prune     = true
      self_heal = true
    }
    sync_options = [
      "CreateNamespace=true"
    ]
    retry = {
      limit = "5"
      backoff = {
        duration     = "30s"
        factor       = "2"
        max_duration = "2m"
      }
    }
  }
}
```

## Multi-Source Helm Values

```hcl
sources = [
  {
    repo_url        = "https://charts.bitnami.com/bitnami"
    chart           = "wordpress"
    target_revision = "23.1.0"
    helm = {
      value_files = ["$values/apps/wordpress/values.yaml"]
    }
  },
  {
    repo_url        = "https://github.com/example/platform-values.git"
    target_revision = "main"
    ref             = "values"
  }
]
```

## When To Use The Manifest Module

Use `argocd-application-manifest` instead when you need exact CRD control over fields that are not exposed by the provider schema yet, including version-specific API additions.
