terraform {
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
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

resource "helm_release" "this" {
  name       = var.name
  chart      = var.chart
  namespace  = var.namespace
  repository = var.repository
  version    = var.chart_version

  atomic                     = var.atomic
  cleanup_on_fail            = var.cleanup_on_fail
  create_namespace           = var.create_namespace
  dependency_update          = var.dependency_update
  description                = var.description
  devel                      = var.devel
  disable_crd_hooks          = var.disable_crd_hooks
  disable_openapi_validation = var.disable_openapi_validation
  disable_webhooks           = var.disable_webhooks
  force_update               = var.force_update
  keyring                    = var.keyring
  lint                       = var.lint
  max_history                = var.max_history
  pass_credentials           = var.pass_credentials
  recreate_pods              = var.recreate_pods
  render_subchart_notes      = var.render_subchart_notes
  replace                    = var.replace
  repository_ca_file         = var.repository_ca_file
  repository_cert_file       = var.repository_cert_file
  repository_key_file        = var.repository_key_file
  repository_password        = var.repository_password
  repository_username        = var.repository_username
  reset_values               = var.reset_values
  reuse_values               = var.reuse_values
  set                        = var.set
  set_list                   = var.set_list
  set_sensitive              = var.set_sensitive
  set_wo                     = var.set_wo
  set_wo_revision            = var.set_wo_revision
  skip_crds                  = var.skip_crds
  take_ownership             = var.take_ownership
  timeout                    = var.timeout
  upgrade_install            = var.upgrade_install
  values                     = var.values
  verify                     = var.verify
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs
  postrender                 = var.postrender
}
