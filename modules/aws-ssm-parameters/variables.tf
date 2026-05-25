variable "kms_key_id" {
  description = "AWS KMS key ID for OpenTofu state encryption. Also used for SSM SecureString encryption when parameter_kms_key_id is not set"
  type        = string
}

variable "kms_region" {
  description = "AWS region for the KMS key used by OpenTofu state encryption"
  type        = string
  default     = "us-west-2"
}

variable "kms_key_spec" {
  description = "AWS KMS key spec for OpenTofu state encryption"
  type        = string
  default     = "AES_256"
}

variable "project_name" {
  description = "Project prefix used for generated IAM reader group names"
  type        = string
  default     = "managed"
}

variable "aws_region" {
  description = "AWS region where SSM parameters and the optional parameter KMS key are managed"
  type        = string
  default     = "us-east-1"
}

variable "parameters" {
  description = "SSM SecureString parameters to create. Values are ignored after creation so real secrets can be rotated outside Terraform"
  type = map(object({
    description   = string
    initial_value = optional(string, "REPLACE_ME")
    tier          = optional(string, "Standard")
    tags          = optional(map(string), {})
  }))
}

variable "parameter_reader_iam_user_names" {
  description = "Existing IAM user names that should be allowed to read and decrypt the managed SSM parameters"
  type        = set(string)
  default     = []
}

variable "parameter_reader_iam_group_name" {
  description = "IAM group name for parameter readers. Defaults to <project_name>-ssm-parameter-readers"
  type        = string
  default     = null
}

variable "parameter_reader_iam_group_policy_name" {
  description = "Inline IAM group policy name for parameter readers. Defaults to <project_name>-ssm-parameter-reader"
  type        = string
  default     = null
}

variable "create_kms_key" {
  description = "Whether to create the KMS key used to encrypt SecureString parameters"
  type        = bool
  default     = false
}

variable "parameter_kms_key_id" {
  description = "KMS key alias, key ID, or ARN used to encrypt SecureString parameters. Defaults to kms_key_id"
  type        = string
  default     = null
}

variable "kms_key_description" {
  description = "Description for the managed parameter KMS key when create_kms_key is true"
  type        = string
  default     = "OpenTofu-managed SSM Parameter Store key."
}

variable "kms_key_deletion_window_in_days" {
  description = "Waiting period before deleting the managed parameter KMS key"
  type        = number
  default     = 30

  validation {
    condition     = var.kms_key_deletion_window_in_days >= 7 && var.kms_key_deletion_window_in_days <= 30
    error_message = "kms_key_deletion_window_in_days must be between 7 and 30."
  }
}

variable "tags" {
  description = "Tags applied to managed SSM parameters and the optional parameter KMS key"
  type        = map(string)
  default     = {}
}
