terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
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

resource "kubernetes_secret_v1" "this" {
  metadata {
    annotations   = var.annotations
    generate_name = var.generate_name
    labels        = var.labels
    name          = var.name
    namespace     = var.namespace
  }

  binary_data                    = var.binary_data
  binary_data_wo                 = var.binary_data_wo
  binary_data_wo_revision        = var.binary_data_wo_revision
  data                           = var.data
  data_wo                        = var.data_wo
  data_wo_revision               = var.data_wo_revision
  immutable                      = var.immutable
  type                           = var.type
  wait_for_service_account_token = var.wait_for_service_account_token

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
    }
  }
}
