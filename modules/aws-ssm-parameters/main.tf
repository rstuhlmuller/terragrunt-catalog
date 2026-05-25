terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
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

data "aws_caller_identity" "current" {}

data "aws_kms_key" "existing" {
  count = var.create_kms_key ? 0 : 1

  key_id = local.parameter_kms_key_id
}

data "aws_iam_policy_document" "kms" {
  # checkov:skip=CKV_AWS_111: KMS key bootstrap policy intentionally grants account-root key administration
  # checkov:skip=CKV_AWS_109: KMS key bootstrap policy must let account-root manage the key policy
  # checkov:skip=CKV_AWS_356: KMS key policies use Resource * because the policy is attached to the key itself
  statement {
    sid = "EnableAccountKeyAdministration"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = ["*"]
  }
}

locals {
  parameter_kms_key_id              = coalesce(var.parameter_kms_key_id, var.kms_key_id)
  parameter_reader_iam_group_name   = coalesce(var.parameter_reader_iam_group_name, "${var.project_name}-ssm-parameter-readers")
  parameter_reader_iam_policy_name  = coalesce(var.parameter_reader_iam_group_policy_name, "${var.project_name}-ssm-parameter-reader")
  effective_parameter_kms_key_id    = var.create_kms_key ? aws_kms_alias.this[0].name : local.parameter_kms_key_id
  effective_parameter_kms_key_arn   = var.create_kms_key ? aws_kms_key.this[0].arn : data.aws_kms_key.existing[0].arn
  create_parameter_reader_iam_group = length(var.parameter_reader_iam_user_names) > 0
  managed_parameter_resource_arns = [
    for name in keys(var.parameters) :
    "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${trimprefix(name, "/")}"
  ]
}

resource "aws_kms_key" "this" {
  count = var.create_kms_key ? 1 : 0

  region                  = var.aws_region
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms.json
  tags                    = var.tags
}

resource "aws_kms_alias" "this" {
  count = var.create_kms_key ? 1 : 0

  region        = var.aws_region
  name          = local.parameter_kms_key_id
  target_key_id = aws_kms_key.this[0].key_id

  lifecycle {
    precondition {
      condition     = startswith(local.parameter_kms_key_id, "alias/")
      error_message = "parameter_kms_key_id, or kms_key_id when parameter_kms_key_id is unset, must be an alias/ name when create_kms_key is true."
    }
  }
}

resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  region      = var.aws_region
  name        = each.key
  description = each.value.description
  type        = "SecureString"
  value       = each.value.initial_value
  key_id      = local.effective_parameter_kms_key_id
  tier        = each.value.tier
  tags        = merge(var.tags, each.value.tags)

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      value,
    ]
  }
}

data "aws_iam_policy_document" "parameter_reader" {
  count = local.create_parameter_reader_iam_group ? 1 : 0

  statement {
    sid = "ReadManagedSsmParameters"

    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = local.managed_parameter_resource_arns
  }

  statement {
    sid = "DecryptManagedSsmParameters"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = [
      local.effective_parameter_kms_key_arn,
    ]
  }
}

resource "aws_iam_group" "parameter_readers" {
  count = local.create_parameter_reader_iam_group ? 1 : 0

  name = local.parameter_reader_iam_group_name
}

resource "aws_iam_group_policy" "parameter_reader" {
  count = local.create_parameter_reader_iam_group ? 1 : 0

  group  = aws_iam_group.parameter_readers[0].name
  name   = local.parameter_reader_iam_policy_name
  policy = data.aws_iam_policy_document.parameter_reader[0].json
}

resource "aws_iam_user_group_membership" "parameter_reader" {
  for_each = var.parameter_reader_iam_user_names

  groups = [
    aws_iam_group.parameter_readers[0].name,
  ]
  user = each.value
}
