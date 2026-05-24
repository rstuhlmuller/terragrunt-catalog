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

resource "nomad_variable" "this" {
  path      = var.path
  namespace = var.namespace
  items     = var.items

  lifecycle {
    ignore_changes = [items]
  }
}
