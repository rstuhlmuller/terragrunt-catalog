terraform {
  required_version = ">= 1.0"

  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.15"
    }
  }

  encryption {
    key_provider "aws_kms" "main" {
      kms_key_id = var.kms_key_id
      key_spec   = var.kms_key_spec
      region     = var.kms_region
    }

    method "aes_gcm" "main" {
      keys = key_provider.aws_kms.main
    }

    state {
      method   = method.aes_gcm.main
      enforced = true
    }

    plan {
      method   = method.aes_gcm.main
      enforced = true
    }
  }
}

resource "argocd_repository" "this" {
  repo = var.repo

  bearer_token                  = var.bearer_token
  depth                         = var.depth
  enable_lfs                    = var.enable_lfs
  enable_oci                    = var.enable_oci
  githubapp_enterprise_base_url = var.githubapp_enterprise_base_url
  githubapp_id                  = var.githubapp_id
  githubapp_installation_id     = var.githubapp_installation_id
  githubapp_private_key         = var.githubapp_private_key
  insecure                      = var.insecure
  name                          = var.name
  no_proxy                      = var.no_proxy
  password                      = var.password
  project                       = var.project
  proxy                         = var.proxy
  ssh_private_key               = var.ssh_private_key
  tls_client_cert_data          = var.tls_client_cert_data
  tls_client_cert_key           = var.tls_client_cert_key
  type                          = var.type
  use_azure_workload_identity   = var.use_azure_workload_identity
  username                      = var.username
}
