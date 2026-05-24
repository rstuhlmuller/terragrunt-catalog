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

variable "api_version" {
  description = "Argo CD ApplicationSet API version"
  type        = string
  default     = "argoproj.io/v1alpha1"
}

variable "name" {
  description = "ApplicationSet name"
  type        = string
}

variable "namespace" {
  description = "Namespace containing the Argo CD ApplicationSet resource"
  type        = string
  default     = "argocd"
}

variable "labels" {
  description = "ApplicationSet labels"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "ApplicationSet annotations"
  type        = map(string)
  default     = {}
}

variable "finalizers" {
  description = "ApplicationSet finalizers"
  type        = list(string)
  default     = []
}

variable "spec" {
  description = "Complete Argo CD ApplicationSet spec"
  type        = any
}

variable "extra_fields" {
  description = "Additional top-level manifest fields to merge into the ApplicationSet"
  type        = map(any)
  default     = {}
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
  description = "Wait configuration for ApplicationSet fields, conditions, or rollout completion"
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
