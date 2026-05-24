# Nomad Application Secrets Unit

This unit manages application configuration and secrets using Nomad variables with encryption.

## Description

Creates a Nomad variable containing:
- Database connection settings
- API configuration
- Application settings
- Feature flags

## Security

Sensitive data is:
- Stored in Nomad's encrypted variables system
- Protected by Nomad ACLs
- Encrypted at rest in OpenTofu state using AWS KMS
- Marked as sensitive in Terraform outputs

## Prerequisites

- Production namespace created (`nomad-production-namespace` unit)
- AWS KMS key created for state encryption
- Nomad ACL tokens with proper permissions

## Usage

```bash
# Initialize and apply
terragrunt init
terragrunt plan
terragrunt apply

# View variable in Nomad
nomad var get -namespace=production myapp/production/config
```

## Using in Nomad Jobs

Reference these variables in your Nomad job templates:

```hcl
job "myapp" {
  namespace = "production"

  group "app" {
    task "server" {
      template {
        data = <<EOT
{{ with nomadVar "myapp/production/config" }}
DB_HOST={{ .db_host }}
DB_PORT={{ .db_port }}
DB_NAME={{ .db_name }}
DB_MAX_CONNS={{ .db_max_conns }}

API_BASE_URL={{ .api_base_url }}
API_TIMEOUT={{ .api_timeout }}

LOG_LEVEL={{ .log_level }}
MAX_WORKERS={{ .max_workers }}
{{ end }}
EOT
        destination = "secrets/.env"
        env         = true
      }
    }
  }
}
```

## Configuration

Update `terragrunt.hcl` with:
- Actual configuration values for your application
- Add or remove items as needed

Set `TOFU_ENCRYPTION_KMS_KEY_ID` in your environment, or override `kms_key_id` in this unit when it needs a dedicated key.

## Security Best Practices

1. Store actual secrets (passwords, API keys) separately using:
   - AWS Secrets Manager
   - HashiCorp Vault
   - External secret management systems

2. Use Nomad variables for:
   - Non-sensitive configuration
   - Connection strings (without credentials)
   - Feature flags
   - Application settings

3. Always encrypt state files with KMS
4. Limit access using Nomad ACL policies
5. Rotate sensitive values regularly
