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
  description = "ConfigMap name. Leave null only when using generate_name"
  type        = string
  default     = null
}

variable "generate_name" {
  description = "Prefix used by the API server to generate a unique ConfigMap name"
  type        = string
  default     = null
}

variable "namespace" {
  description = "ConfigMap namespace. Set this explicitly to avoid using the Kubernetes default namespace"
  type        = string
}

variable "labels" {
  description = "ConfigMap labels"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "ConfigMap annotations"
  type        = map(string)
  default     = {}
}

variable "data" {
  description = "UTF-8 ConfigMap data"
  type        = map(string)
  default     = {}
}

variable "binary_data" {
  description = "Base64-encoded binary ConfigMap data"
  type        = map(string)
  default     = {}
}

variable "immutable" {
  description = "Prevent updates to ConfigMap data after creation"
  type        = bool
  default     = null
}
