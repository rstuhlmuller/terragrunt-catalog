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

locals {
  metadata = merge(
    {
      name = var.name
    },
    var.namespace != null ? { namespace = var.namespace } : {},
    length(var.annotations) > 0 ? { annotations = var.annotations } : {},
    length(var.labels) > 0 ? { labels = var.labels } : {},
    length(var.finalizers) > 0 ? { finalizers = var.finalizers } : {}
  )

  manifest = merge(
    {
      apiVersion = var.api_version
      kind       = "Application"
      metadata   = local.metadata
      spec       = var.spec
    },
    var.extra_fields
  )
}

resource "kubernetes_manifest" "this" {
  manifest        = local.manifest
  computed_fields = var.computed_fields

  dynamic "field_manager" {
    for_each = var.field_manager != null ? [var.field_manager] : []
    content {
      force_conflicts = try(field_manager.value.force_conflicts, null)
      name            = try(field_manager.value.name, null)
    }
  }

  dynamic "wait" {
    for_each = var.wait != null ? [var.wait] : []
    content {
      fields  = try(wait.value.fields, null)
      rollout = try(wait.value.rollout, null)

      dynamic "condition" {
        for_each = try(wait.value.conditions, [])
        content {
          status = try(condition.value.status, null)
          type   = try(condition.value.type, null)
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      delete = try(timeouts.value.delete, null)
      update = try(timeouts.value.update, null)
    }
  }
}
