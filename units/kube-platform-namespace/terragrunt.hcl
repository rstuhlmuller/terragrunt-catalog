include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/kube-namespace-v1"
}

inputs = {
  name = "platform"

  labels = {
    "app.kubernetes.io/managed-by" = "terragrunt"
    "platform.example.com/tier"    = "shared"
  }

  annotations = {
    "platform.example.com/owner" = "platform-engineering"
  }

  wait_for_default_service_account = true
}
