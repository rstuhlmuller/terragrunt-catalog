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

variable "namespace" {
  description = "The namespace in which to register the volume"
  type        = string
  default     = "default"
}

variable "volume_id" {
  description = "The unique ID of the volume in Nomad"
  type        = string
}

variable "name" {
  description = "The display name for the volume"
  type        = string
}

variable "plugin_id" {
  description = "The ID of the Nomad CSI plugin for registering this volume"
  type        = string
}

variable "external_id" {
  description = "The ID of the physical volume from the storage provider"
  type        = string
}

variable "capacity_min" {
  description = "Minimum volume size (e.g., '10GiB'). May not be supported by all storage providers"
  type        = string
  default     = null
}

variable "capacity_max" {
  description = "Maximum volume size (e.g., '20GiB'). May not be supported by all storage providers"
  type        = string
  default     = null
}

variable "capabilities" {
  description = "List of capabilities for the volume"
  type = list(object({
    access_mode     = string # single-node-reader-only, single-node-writer, multi-node-reader-only, multi-node-single-writer, multi-node-multi-writer
    attachment_mode = string # block-device, file-system
  }))
}

variable "mount_options" {
  description = "Options for mounting block-device volumes without a pre-formatted file system"
  type = object({
    fs_type     = optional(string)
    mount_flags = optional(list(string))
  })
  default = null
}

variable "topology_request" {
  description = "Specify locations (region, zone, rack, etc.) where the volume is accessible from"
  type = object({
    required = optional(object({
      topologies = list(object({
        segments = map(string)
      }))
    }))
  })
  default = null
}

variable "secrets" {
  description = "Key-value map of strings used as credentials for publishing and unpublishing volumes"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "parameters" {
  description = "Key-value map of strings passed directly to the CSI plugin to configure the volume"
  type        = map(string)
  default     = {}
}

variable "context" {
  description = "Key-value map of strings passed directly to the CSI plugin to validate the volume"
  type        = map(string)
  default     = {}
}

variable "deregister_on_destroy" {
  description = "If true, the volume will be deregistered when the resource is destroyed"
  type        = bool
  default     = true
}

variable "timeouts" {
  description = "Timeout configuration for volume operations"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null
}
