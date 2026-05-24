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

variable "manifest" {
  description = "Kubernetes manifest as an HCL object. Use yamldecode(file(...)) for YAML manifests"
  type        = any
}

variable "computed_fields" {
  description = "Manifest field paths that may be changed by the API server or admission controllers"
  type        = list(string)
  default     = null
}

variable "field_manager" {
  description = "Server-side apply field manager configuration"
  type = object({
    force_conflicts = optional(bool)
    name            = optional(string)
  })
  default = null
}

variable "wait" {
  description = "Wait configuration for resource fields, conditions, or rollout completion"
  type = object({
    fields  = optional(map(string))
    rollout = optional(bool)
    conditions = optional(list(object({
      status = optional(string)
      type   = optional(string)
    })), [])
  })
  default = null
}

variable "timeouts" {
  description = "Timeout configuration for manifest operations"
  type = object({
    create = optional(string)
    delete = optional(string)
    update = optional(string)
  })
  default = null
}
