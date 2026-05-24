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
  description = "Namespace name. Leave null only when using generate_name"
  type        = string
  default     = null
}

variable "generate_name" {
  description = "Prefix used by the API server to generate a unique namespace name"
  type        = string
  default     = null
}

variable "labels" {
  description = "Namespace labels"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Namespace annotations"
  type        = map(string)
  default     = {}
}

variable "wait_for_default_service_account" {
  description = "Wait for the namespace default service account to be created"
  type        = bool
  default     = false
}

variable "timeouts" {
  description = "Timeout configuration for namespace operations"
  type = object({
    delete = optional(string)
  })
  default = null
}
