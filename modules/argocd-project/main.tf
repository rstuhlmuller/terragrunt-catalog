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

resource "argocd_project" "this" {
  metadata {
    annotations = try(var.metadata.annotations, {})
    labels      = try(var.metadata.labels, {})
    name        = var.metadata.name
    namespace   = try(var.metadata.namespace, "argocd")
  }

  spec {
    description       = var.description
    signature_keys    = var.signature_keys
    source_namespaces = var.source_namespaces
    source_repos      = var.source_repos

    dynamic "cluster_resource_blacklist" {
      for_each = var.cluster_resource_blacklist
      content {
        group = try(cluster_resource_blacklist.value.group, null)
        kind  = try(cluster_resource_blacklist.value.kind, null)
      }
    }

    dynamic "cluster_resource_whitelist" {
      for_each = var.cluster_resource_whitelist
      content {
        group = try(cluster_resource_whitelist.value.group, null)
        kind  = try(cluster_resource_whitelist.value.kind, null)
      }
    }

    dynamic "destination" {
      for_each = var.destinations
      content {
        name      = try(destination.value.name, null)
        namespace = destination.value.namespace
        server    = try(destination.value.server, null)
      }
    }

    dynamic "destination_service_account" {
      for_each = var.destination_service_accounts
      content {
        default_service_account = destination_service_account.value.default_service_account
        namespace               = try(destination_service_account.value.namespace, null)
        server                  = try(destination_service_account.value.server, null)
      }
    }

    dynamic "namespace_resource_blacklist" {
      for_each = var.namespace_resource_blacklist
      content {
        group = try(namespace_resource_blacklist.value.group, null)
        kind  = try(namespace_resource_blacklist.value.kind, null)
      }
    }

    dynamic "namespace_resource_whitelist" {
      for_each = var.namespace_resource_whitelist
      content {
        group = try(namespace_resource_whitelist.value.group, null)
        kind  = try(namespace_resource_whitelist.value.kind, null)
      }
    }

    dynamic "orphaned_resources" {
      for_each = var.orphaned_resources != null ? [var.orphaned_resources] : []
      content {
        warn = try(orphaned_resources.value.warn, null)

        dynamic "ignore" {
          for_each = try(orphaned_resources.value.ignore, [])
          content {
            group = try(ignore.value.group, null)
            kind  = try(ignore.value.kind, null)
            name  = try(ignore.value.name, null)
          }
        }
      }
    }

    dynamic "role" {
      for_each = var.roles
      content {
        description = try(role.value.description, null)
        groups      = try(role.value.groups, null)
        name        = role.value.name
        policies    = role.value.policies
      }
    }

    dynamic "sync_window" {
      for_each = var.sync_windows
      content {
        applications     = try(sync_window.value.applications, null)
        clusters         = try(sync_window.value.clusters, null)
        duration         = try(sync_window.value.duration, null)
        kind             = try(sync_window.value.kind, null)
        manual_sync      = try(sync_window.value.manual_sync, null)
        namespaces       = try(sync_window.value.namespaces, null)
        schedule         = try(sync_window.value.schedule, null)
        timezone         = try(sync_window.value.timezone, null)
        use_and_operator = try(sync_window.value.use_and_operator, null)
      }
    }
  }
}
