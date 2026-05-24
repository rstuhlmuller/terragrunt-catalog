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

variable "repo" {
  description = "Git, Helm, or OCI repository URL"
  type        = string
}

variable "type" {
  description = "Repository type: git, helm, or oci"
  type        = string
  default     = null
}

variable "name" {
  description = "Repository display name. Used primarily for Helm repositories"
  type        = string
  default     = null
}

variable "project" {
  description = "Project name for project-scoped repositories"
  type        = string
  default     = null
}

variable "username" {
  description = "Repository username"
  type        = string
  default     = null
}

variable "password" {
  description = "Repository password or token"
  type        = string
  default     = null
  sensitive   = true
}

variable "bearer_token" {
  description = "Bearer token for repository authentication"
  type        = string
  default     = null
  sensitive   = true
}

variable "ssh_private_key" {
  description = "PEM data for SSH repository authentication"
  type        = string
  default     = null
  sensitive   = true
}

variable "tls_client_cert_data" {
  description = "TLS client certificate PEM data"
  type        = string
  default     = null
}

variable "tls_client_cert_key" {
  description = "TLS client certificate key PEM data"
  type        = string
  default     = null
  sensitive   = true
}

variable "githubapp_id" {
  description = "GitHub App ID"
  type        = string
  default     = null
}

variable "githubapp_installation_id" {
  description = "GitHub App installation ID"
  type        = string
  default     = null
}

variable "githubapp_private_key" {
  description = "GitHub App private key PEM data"
  type        = string
  default     = null
  sensitive   = true
}

variable "githubapp_enterprise_base_url" {
  description = "GitHub Enterprise API base URL for GitHub App authentication"
  type        = string
  default     = null
}

variable "depth" {
  description = "Git shallow clone depth. Use 0 for full clone"
  type        = number
  default     = null
}

variable "enable_lfs" {
  description = "Enable Git LFS support for this repository"
  type        = bool
  default     = null
}

variable "enable_oci" {
  description = "Enable Helm OCI support for this repository"
  type        = bool
  default     = null
}

variable "insecure" {
  description = "Ignore TLS certificate or SSH host key verification errors"
  type        = bool
  default     = null
}

variable "proxy" {
  description = "HTTP or HTTPS proxy to access the repository"
  type        = string
  default     = null
}

variable "no_proxy" {
  description = "Comma-separated hostnames excluded from proxying"
  type        = string
  default     = null
}

variable "use_azure_workload_identity" {
  description = "Enable Azure workload identity for this repository"
  type        = bool
  default     = null
}
