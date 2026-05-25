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

variable "client_id" {
  description = "Client ID of the application for which to create a service principal"
  type        = string
}

variable "account_enabled" {
  description = "Whether the service principal account is enabled"
  type        = bool
  default     = null
}

variable "alternative_names" {
  description = "Alternative names for the service principal"
  type        = set(string)
  default     = null
}

variable "app_role_assignment_required" {
  description = "Whether app role assignment is required before issuing tokens to users"
  type        = bool
  default     = null
}

variable "description" {
  description = "Description of the service principal"
  type        = string
  default     = null
}

variable "feature_tags" {
  description = "Well-known feature tags for enterprise/gallery service principal behavior. Mutually exclusive with tags"
  type = object({
    custom_single_sign_on = optional(bool)
    enterprise            = optional(bool)
    gallery               = optional(bool)
    hide                  = optional(bool)
  })
  default = null
}

variable "login_url" {
  description = "URL where the service provider redirects users to authenticate"
  type        = string
  default     = null
}

variable "notes" {
  description = "Free text notes for the service principal"
  type        = string
  default     = null
}

variable "notification_email_addresses" {
  description = "Email addresses that receive certificate expiration notifications"
  type        = set(string)
  default     = null
}

variable "owners" {
  description = "Object IDs of owners for the service principal"
  type        = set(string)
  default     = null
}

variable "preferred_single_sign_on_mode" {
  description = "Preferred single sign-on mode for launching the application"
  type        = string
  default     = null

  validation {
    condition     = var.preferred_single_sign_on_mode == null || contains(["oidc", "password", "saml", "notSupported"], var.preferred_single_sign_on_mode)
    error_message = "preferred_single_sign_on_mode must be oidc, password, saml, notSupported, or null."
  }
}

variable "saml_single_sign_on" {
  description = "SAML single sign-on settings"
  type = object({
    relay_state = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Service principal tags. Mutually exclusive with feature_tags"
  type        = set(string)
  default     = null
}

variable "use_existing" {
  description = "Import an existing service principal linked to the same application when present"
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Timeout configuration for service principal operations"
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default = null
}
