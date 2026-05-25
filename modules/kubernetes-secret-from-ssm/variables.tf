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
  description = "Name of the Kubernetes Secret to create"
  type        = string
}

variable "namespace" {
  description = "Namespace where the Kubernetes Secret should be created"
  type        = string
}

variable "data_ssm_parameter_names" {
  description = "Map of Kubernetes Secret keys to encrypted AWS SSM parameter names"
  type        = map(string)
}

variable "type" {
  description = "Kubernetes Secret type"
  type        = string
  default     = "Opaque"
}

variable "labels" {
  description = "Labels to apply to the Kubernetes Secret"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the Kubernetes Secret"
  type        = map(string)
  default     = {}
}

variable "immutable" {
  description = "Prevent updates to Secret data after creation"
  type        = bool
  default     = null
}

variable "placeholder_value" {
  description = "Placeholder value that must be replaced before creating the Kubernetes Secret"
  type        = string
  default     = "REPLACE_ME"
}
