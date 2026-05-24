include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/argocd-application"
}

inputs = {
  metadata = {
    name      = "guestbook"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/managed-by" = "terragrunt"
      "app.kubernetes.io/part-of"    = "example"
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

  ignore_differences = [
    {
      group         = "apps"
      kind          = "Deployment"
      json_pointers = ["/spec/replicas"]
    }
  ]
}
