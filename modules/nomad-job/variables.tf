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

variable "jobspec_content" {
  description = "Inline jobspec content (HCL or JSON)"
  type        = string
  default     = null
}

variable "jobspec_file" {
  description = "Path to jobspec file"
  type        = string
  default     = null
}

variable "json_format" {
  description = "Whether the jobspec is in JSON format"
  type        = bool
  default     = false
}

variable "deregister_on_destroy" {
  description = "Deregister job when resource is destroyed"
  type        = bool
  default     = true
}

variable "purge_on_destroy" {
  description = "Purge job when resource is destroyed"
  type        = bool
  default     = false
}

variable "deregister_on_id_change" {
  description = "Deregister job if the ID changes"
  type        = bool
  default     = true
}

variable "rerun_if_dead" {
  description = "Force job to run again if status is dead"
  type        = bool
  default     = false
}

variable "detach" {
  description = "Return immediately after creating/updating"
  type        = bool
  default     = true
}

variable "policy_override" {
  description = "Override soft-mandatory Sentinel policies"
  type        = bool
  default     = false
}

variable "hcl2_enabled" {
  description = "Enable HCL2 parser options"
  type        = bool
  default     = false
}

variable "hcl2_allow_fs" {
  description = "Allow HCL2 filesystem functions"
  type        = bool
  default     = false
}

variable "hcl2_vars" {
  description = "Variables to pass to HCL2 parser (all values must be strings)"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeout configuration for job operations"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
  })
  default = null
}
