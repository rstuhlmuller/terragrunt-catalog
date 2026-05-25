# Root Terragrunt Configuration
# This file is included by all child units using find_in_parent_folders()

locals {
  # AWS configuration
  aws_region = get_env("AWS_REGION", "us-east-1")

  # OpenTofu encryption configuration
  opentofu_encryption_kms_key_id   = get_env("TOFU_ENCRYPTION_KMS_KEY_ID", "arn:aws:kms:${local.aws_region}:123456789012:key/12345678-1234-1234-1234-123456789012")
  opentofu_encryption_kms_region   = get_env("TOFU_ENCRYPTION_KMS_REGION", local.aws_region)
  opentofu_encryption_kms_key_spec = get_env("TOFU_ENCRYPTION_KMS_KEY_SPEC", "AES_256")

  # Nomad configuration
  nomad_address = get_env("NOMAD_ADDR", "http://localhost:4646")
  nomad_token   = get_env("NOMAD_TOKEN", "")

  # Kubernetes and Helm configuration
  kubernetes_config_path    = get_env("KUBE_CONFIG_PATH", "~/.kube/config")
  kubernetes_config_context = get_env("KUBE_CTX", "")
  kubernetes_context_line   = local.kubernetes_config_context != "" ? "  config_context = \"${local.kubernetes_config_context}\"\n" : ""
  helm_context_line         = local.kubernetes_config_context != "" ? "    config_context = \"${local.kubernetes_config_context}\"\n" : ""

  # Environment configuration
  environment = get_env("ENVIRONMENT", "dev")
}

# Configure Terragrunt to use S3 backend with encryption
remote_state {
  backend = "s3"

  config = {
    bucket         = "my-terraform-state-${local.environment}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "terraform-state-lock-${local.environment}"

    # S3 bucket encryption
    kms_key_id = local.opentofu_encryption_kms_key_id
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "nomad" {
  address = "${local.nomad_address}"
  token   = "${local.nomad_token}"
  region  = "global"
}

provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = {
      ManagedBy   = "Terragrunt"
      Environment = "${local.environment}"
      Repository  = "terragrunt-catalog"
    }
  }
}

provider "kubernetes" {
  config_path = "${local.kubernetes_config_path}"
${local.kubernetes_context_line}}

provider "helm" {
  kubernetes = {
    config_path = "${local.kubernetes_config_path}"
${local.helm_context_line}  }
}

provider "argocd" {}

provider "azuread" {}
EOF
}

# Retry configuration for transient errors
errors {
  retry "transient_errors" {
    retryable_errors = [
      "(?s).*failed to dial.*",
      "(?s).*connection refused.*",
      "(?s).*timeout.*",
      "(?s).*TLS handshake timeout.*",
    ]

    max_attempts       = 3
    sleep_interval_sec = 5
  }
}

# Input variables that can be used by all child configurations
inputs = {
  aws_region                = local.aws_region
  environment               = local.environment
  kms_key_id                = local.opentofu_encryption_kms_key_id
  kms_region                = local.opentofu_encryption_kms_region
  kms_key_spec              = local.opentofu_encryption_kms_key_spec
  nomad_address             = local.nomad_address
  kubernetes_config_path    = local.kubernetes_config_path
  kubernetes_config_context = local.kubernetes_config_context
}
