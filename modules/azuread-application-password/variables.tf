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

variable "application_id" {
  description = "Resource ID of the application registration that owns this password"
  type        = string
}

variable "display_name" {
  description = "Display name for the application password"
  type        = string
  default     = null
}

variable "end_date" {
  description = "End date and time for the password in RFC3339 format"
  type        = string
  default     = null
}

variable "end_date_relative" {
  description = "Relative duration after which the password expires"
  type        = string
  default     = null
}

variable "rotate_when_changed" {
  description = "Arbitrary key/value map that forces password rotation when changed"
  type        = map(string)
  default     = null
}

variable "start_date" {
  description = "Start date and time for the password in RFC3339 format"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeout configuration for application password operations"
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}
