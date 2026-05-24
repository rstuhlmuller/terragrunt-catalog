terraform {
  required_version = ">= 1.0"

  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.6.0"
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

resource "nomad_namespace" "this" {
  name        = var.name
  description = var.description
  quota       = var.quota
  meta        = var.meta

  dynamic "capabilities" {
    for_each = var.capabilities != null ? [var.capabilities] : []
    content {
      enabled_task_drivers   = lookup(capabilities.value, "enabled_task_drivers", null)
      disabled_task_drivers  = lookup(capabilities.value, "disabled_task_drivers", null)
      enabled_network_modes  = lookup(capabilities.value, "enabled_network_modes", null)
      disabled_network_modes = lookup(capabilities.value, "disabled_network_modes", null)
    }
  }

  dynamic "node_pool_config" {
    for_each = var.node_pool_config != null ? [var.node_pool_config] : []
    content {
      default = lookup(node_pool_config.value, "default", null)
      allowed = lookup(node_pool_config.value, "allowed", null)
      denied  = lookup(node_pool_config.value, "denied", null)
    }
  }
}
