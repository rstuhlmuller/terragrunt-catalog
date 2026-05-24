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

variable "metadata" {
  description = "Project Kubernetes metadata"
  type = object({
    annotations = optional(map(string), {})
    labels      = optional(map(string), {})
    name        = string
    namespace   = optional(string, "argocd")
  })
}

variable "description" {
  description = "Project description"
  type        = string
  default     = null
}

variable "source_namespaces" {
  description = "Namespaces from which applications may be created"
  type        = list(string)
  default     = []
}

variable "source_repos" {
  description = "Repositories from which applications may be created"
  type        = list(string)
  default     = []
}

variable "destinations" {
  description = "Destinations available for deployment"
  type = list(object({
    name      = optional(string)
    namespace = string
    server    = optional(string)
  }))
  default = []
}

variable "destination_service_accounts" {
  description = "Destination-specific service accounts to impersonate during sync"
  type = list(object({
    default_service_account = string
    namespace               = optional(string)
    server                  = optional(string)
  }))
  default = []
}

variable "cluster_resource_blacklist" {
  description = "Cluster-scoped resources forbidden in the project"
  type = list(object({
    group = optional(string)
    kind  = optional(string)
  }))
  default = []
}

variable "cluster_resource_whitelist" {
  description = "Cluster-scoped resources allowed in the project"
  type = list(object({
    group = optional(string)
    kind  = optional(string)
  }))
  default = []
}

variable "namespace_resource_blacklist" {
  description = "Namespace-scoped resources forbidden in the project"
  type = list(object({
    group = optional(string)
    kind  = optional(string)
  }))
  default = []
}

variable "namespace_resource_whitelist" {
  description = "Namespace-scoped resources allowed in the project"
  type = list(object({
    group = optional(string)
    kind  = optional(string)
  }))
  default = []
}

variable "orphaned_resources" {
  description = "Orphaned resource detection configuration"
  type = object({
    warn = optional(bool)
    ignore = optional(list(object({
      group = optional(string)
      kind  = optional(string)
      name  = optional(string)
    })), [])
  })
  default = null
}

variable "roles" {
  description = "Project roles and Casbin policies"
  type = list(object({
    description = optional(string)
    groups      = optional(list(string))
    name        = string
    policies    = list(string)
  }))
  default = []
}

variable "signature_keys" {
  description = "GPG key IDs allowed for source signature verification"
  type        = list(string)
  default     = []
}

variable "sync_windows" {
  description = "Project sync windows"
  type = list(object({
    applications     = optional(list(string))
    clusters         = optional(list(string))
    duration         = optional(string)
    kind             = optional(string)
    manual_sync      = optional(bool)
    namespaces       = optional(list(string))
    schedule         = optional(string)
    timezone         = optional(string)
    use_and_operator = optional(bool)
  }))
  default = []
}
