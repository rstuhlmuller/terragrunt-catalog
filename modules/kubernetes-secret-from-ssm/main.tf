terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

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

data "aws_ssm_parameter" "secret_data" {
  for_each = var.data_ssm_parameter_names

  name            = each.value
  with_decryption = true
}

locals {
  secret_data = {
    for key, parameter in data.aws_ssm_parameter.secret_data :
    key => parameter.value
  }

  invalid_secret_keys = [
    for key, value in local.secret_data :
    key
    if trimspace(nonsensitive(value)) == "" || trimspace(nonsensitive(value)) == var.placeholder_value
  ]
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    annotations = var.annotations
    labels      = var.labels
    name        = var.name
    namespace   = var.namespace
  }

  data      = local.secret_data
  immutable = var.immutable
  type      = var.type

  lifecycle {
    precondition {
      condition     = length(local.invalid_secret_keys) == 0
      error_message = "SSM parameters for Kubernetes Secret keys ${join(", ", local.invalid_secret_keys)} are empty or still set to the placeholder value."
    }
  }
}
