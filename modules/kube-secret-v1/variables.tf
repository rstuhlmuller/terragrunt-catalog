variable "kms_key_id" {
  description = "AWS KMS key ID for OpenTofu state encryption"
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

variable "name" {
  description = "Secret name. Leave null only when using generate_name"
  type        = string
  default     = null
}

variable "generate_name" {
  description = "Prefix used by the API server to generate a unique Secret name"
  type        = string
  default     = null
}

variable "namespace" {
  description = "Secret namespace. Set this explicitly to avoid using the Kubernetes default namespace"
  type        = string
}

variable "labels" {
  description = "Secret labels"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Secret annotations"
  type        = map(string)
  default     = {}
}

variable "data" {
  description = "Sensitive UTF-8 secret data stored in Terraform state"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "binary_data" {
  description = "Sensitive base64-encoded binary secret data stored in Terraform state"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "data_wo" {
  description = "Write-only UTF-8 secret data for providers that support write-only inputs"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "data_wo_revision" {
  description = "Revision number for write-only UTF-8 secret data. Increment to force an update"
  type        = number
  default     = null
}

variable "binary_data_wo" {
  description = "Write-only base64-encoded binary secret data for providers that support write-only inputs"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "binary_data_wo_revision" {
  description = "Revision number for write-only binary secret data. Increment to force an update"
  type        = number
  default     = null
}

variable "immutable" {
  description = "Prevent updates to Secret data after creation"
  type        = bool
  default     = null
}

variable "type" {
  description = "Secret type"
  type        = string
  default     = "Opaque"
}

variable "wait_for_service_account_token" {
  description = "Wait for service account token data to be populated"
  type        = bool
  default     = false
}

variable "timeouts" {
  description = "Timeout configuration for secret operations"
  type = object({
    create = optional(string)
  })
  default = null
}
