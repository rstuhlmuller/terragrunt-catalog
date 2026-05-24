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

resource "nomad_csi_volume" "this" {
  namespace = var.namespace
  volume_id = var.volume_id
  name      = var.name
  plugin_id = var.plugin_id

  snapshot_id = var.snapshot_id
  clone_id    = var.clone_id

  capacity_min = var.capacity_min
  capacity_max = var.capacity_max

  dynamic "capability" {
    for_each = var.capabilities
    content {
      access_mode     = capability.value.access_mode
      attachment_mode = capability.value.attachment_mode
    }
  }

  dynamic "mount_options" {
    for_each = var.mount_options != null ? [var.mount_options] : []
    content {
      fs_type     = lookup(mount_options.value, "fs_type", null)
      mount_flags = lookup(mount_options.value, "mount_flags", null)
    }
  }

  dynamic "topology_request" {
    for_each = var.topology_request != null ? [var.topology_request] : []
    content {
      dynamic "required" {
        for_each = lookup(topology_request.value, "required", null) != null ? [topology_request.value.required] : []
        content {
          dynamic "topology" {
            for_each = required.value.topologies
            content {
              segments = topology.value.segments
            }
          }
        }
      }

      dynamic "preferred" {
        for_each = lookup(topology_request.value, "preferred", null) != null ? [topology_request.value.preferred] : []
        content {
          dynamic "topology" {
            for_each = preferred.value.topologies
            content {
              segments = topology.value.segments
            }
          }
        }
      }
    }
  }

  secrets    = var.secrets
  parameters = var.parameters

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = lookup(timeouts.value, "create", "10m")
      delete = lookup(timeouts.value, "delete", "10m")
    }
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}
