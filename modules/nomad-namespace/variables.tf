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
  description = "A unique name for the namespace"
  type        = string
}

variable "description" {
  description = "A description of the namespace"
  type        = string
  default     = ""
}

variable "quota" {
  description = "A resource quota to attach to the namespace"
  type        = string
  default     = ""
}

variable "meta" {
  description = "Arbitrary KV metadata to associate with the namespace"
  type        = map(string)
  default     = {}
}

variable "capabilities" {
  description = "Capabilities configuration for the namespace"
  type = object({
    enabled_task_drivers   = optional(list(string))
    disabled_task_drivers  = optional(list(string))
    enabled_network_modes  = optional(list(string))
    disabled_network_modes = optional(list(string))
  })
  default = null
}

variable "node_pool_config" {
  description = "Node pool configuration for the namespace (Enterprise only)"
  type = object({
    default = optional(string)
    allowed = optional(list(string))
    denied  = optional(list(string))
  })
  default = null
}
