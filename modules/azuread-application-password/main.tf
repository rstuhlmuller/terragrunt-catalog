terraform {
  required_version = ">= 1.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
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

resource "azuread_application_password" "this" {
  application_id      = var.application_id
  display_name        = var.display_name
  end_date            = var.end_date
  end_date_relative   = var.end_date_relative
  rotate_when_changed = var.rotate_when_changed
  start_date          = var.start_date

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      delete = try(timeouts.value.delete, null)
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
    }
  }

  lifecycle {
    precondition {
      condition     = var.end_date == null || var.end_date_relative == null
      error_message = "Use either end_date or end_date_relative, not both."
    }
  }
}
