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

resource "argocd_application" "this" {
  cascade  = var.cascade
  sync     = var.sync
  validate = var.validate
  wait     = var.wait

  metadata {
    annotations = try(var.metadata.annotations, {})
    labels      = try(var.metadata.labels, {})
    name        = var.metadata.name
    namespace   = try(var.metadata.namespace, "argocd")
  }

  spec {
    project                = var.project
    revision_history_limit = var.revision_history_limit

    destination {
      name      = try(var.destination.name, null)
      namespace = try(var.destination.namespace, null)
      server    = try(var.destination.server, null)
    }

    dynamic "source" {
      for_each = var.sources
      content {
        chart           = try(source.value.chart, null)
        name            = try(source.value.name, null)
        path            = try(source.value.path, null)
        ref             = try(source.value.ref, null)
        repo_url        = source.value.repo_url
        target_revision = try(source.value.target_revision, null)

        dynamic "directory" {
          for_each = try(source.value.directory, null) != null ? [source.value.directory] : []
          content {
            exclude = try(directory.value.exclude, null)
            include = try(directory.value.include, null)
            recurse = try(directory.value.recurse, null)

            dynamic "jsonnet" {
              for_each = try(directory.value.jsonnet, null) != null ? [directory.value.jsonnet] : []
              content {
                libs = try(jsonnet.value.libs, null)

                dynamic "ext_var" {
                  for_each = try(jsonnet.value.ext_vars, [])
                  content {
                    code  = try(ext_var.value.code, null)
                    name  = try(ext_var.value.name, null)
                    value = try(ext_var.value.value, null)
                  }
                }

                dynamic "tla" {
                  for_each = try(jsonnet.value.tlas, [])
                  content {
                    code  = try(tla.value.code, null)
                    name  = try(tla.value.name, null)
                    value = try(tla.value.value, null)
                  }
                }
              }
            }
          }
        }

        dynamic "helm" {
          for_each = try(source.value.helm, null) != null ? [source.value.helm] : []
          content {
            ignore_missing_value_files = try(helm.value.ignore_missing_value_files, null)
            pass_credentials           = try(helm.value.pass_credentials, null)
            release_name               = try(helm.value.release_name, null)
            skip_crds                  = try(helm.value.skip_crds, null)
            skip_schema_validation     = try(helm.value.skip_schema_validation, null)
            value_files                = try(helm.value.value_files, null)
            values                     = try(helm.value.values, null)
            version                    = try(helm.value.version, null)

            dynamic "file_parameter" {
              for_each = try(helm.value.file_parameters, [])
              content {
                name = file_parameter.value.name
                path = file_parameter.value.path
              }
            }

            dynamic "parameter" {
              for_each = try(helm.value.parameters, [])
              content {
                force_string = try(parameter.value.force_string, null)
                name         = parameter.value.name
                value        = try(parameter.value.value, null)
              }
            }
          }
        }

        dynamic "kustomize" {
          for_each = try(source.value.kustomize, null) != null ? [source.value.kustomize] : []
          content {
            common_annotations = try(kustomize.value.common_annotations, null)
            common_labels      = try(kustomize.value.common_labels, null)
            images             = try(kustomize.value.images, null)
            name_prefix        = try(kustomize.value.name_prefix, null)
            name_suffix        = try(kustomize.value.name_suffix, null)
            version            = try(kustomize.value.version, null)

            dynamic "patches" {
              for_each = try(kustomize.value.patches, [])
              content {
                options = try(patches.value.options, null)
                patch   = try(patches.value.patch, null)
                path    = try(patches.value.path, null)

                target {
                  annotation_selector = try(patches.value.target.annotation_selector, null)
                  group               = try(patches.value.target.group, null)
                  kind                = try(patches.value.target.kind, null)
                  label_selector      = try(patches.value.target.label_selector, null)
                  name                = try(patches.value.target.name, null)
                  namespace           = try(patches.value.target.namespace, null)
                  version             = try(patches.value.target.version, null)
                }
              }
            }
          }
        }

        dynamic "plugin" {
          for_each = try(source.value.plugin, null) != null ? [source.value.plugin] : []
          content {
            name = try(plugin.value.name, null)

            dynamic "env" {
              for_each = try(plugin.value.env, [])
              content {
                name  = env.value.name
                value = env.value.value
              }
            }
          }
        }
      }
    }

    dynamic "ignore_difference" {
      for_each = var.ignore_differences
      content {
        group                   = try(ignore_difference.value.group, null)
        jq_path_expressions     = try(ignore_difference.value.jq_path_expressions, null)
        json_pointers           = try(ignore_difference.value.json_pointers, null)
        kind                    = try(ignore_difference.value.kind, null)
        managed_fields_managers = try(ignore_difference.value.managed_fields_managers, null)
        name                    = try(ignore_difference.value.name, null)
        namespace               = try(ignore_difference.value.namespace, null)
      }
    }

    dynamic "info" {
      for_each = var.info
      content {
        name  = info.value.name
        value = info.value.value
      }
    }

    dynamic "sync_policy" {
      for_each = var.sync_policy != null ? [var.sync_policy] : []
      content {
        sync_options = try(sync_policy.value.sync_options, null)

        dynamic "automated" {
          for_each = try(sync_policy.value.automated, null) != null ? [sync_policy.value.automated] : []
          content {
            allow_empty = try(automated.value.allow_empty, null)
            prune       = try(automated.value.prune, null)
            self_heal   = try(automated.value.self_heal, null)
          }
        }

        dynamic "managed_namespace_metadata" {
          for_each = try(sync_policy.value.managed_namespace_metadata, null) != null ? [sync_policy.value.managed_namespace_metadata] : []
          content {
            annotations = try(managed_namespace_metadata.value.annotations, null)
            labels      = try(managed_namespace_metadata.value.labels, null)
          }
        }

        dynamic "retry" {
          for_each = try(sync_policy.value.retry, null) != null ? [sync_policy.value.retry] : []
          content {
            limit = try(retry.value.limit, null)

            dynamic "backoff" {
              for_each = try(retry.value.backoff, null) != null ? [retry.value.backoff] : []
              content {
                duration     = try(backoff.value.duration, null)
                factor       = try(backoff.value.factor, null)
                max_duration = try(backoff.value.max_duration, null)
              }
            }
          }
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
