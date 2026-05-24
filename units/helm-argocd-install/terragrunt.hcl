include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/helm-release"
}

inputs = {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
      }
      server = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]

  wait          = true
  wait_for_jobs = true
  timeout       = 600
}
