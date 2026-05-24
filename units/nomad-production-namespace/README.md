# Nomad Production Namespace Unit

This unit creates a production namespace in Nomad with security restrictions and metadata tagging.

## Description

Creates a production namespace with:
- Restricted task drivers (no raw_exec for security)
- Allowed network modes (bridge and host)
- Metadata for tracking and compliance
- OpenTofu state encryption

## Security Considerations

This namespace configuration:
- Disables `raw_exec` driver to prevent arbitrary command execution
- Allows only `docker` and `exec` drivers
- Tags resources for compliance tracking
- Encrypts state files with AWS KMS

## Prerequisites

- Nomad cluster with ACLs enabled (recommended for production)
- AWS KMS key created for state encryption
- Proper IAM permissions for KMS operations

## Usage

```bash
# Initialize and apply
terragrunt init
terragrunt plan
terragrunt apply

# Verify namespace
nomad namespace list
nomad namespace status production
```

## Configuration

Update the following in `terragrunt.hcl`:
- `meta`: Update with your organization's metadata
- `capabilities`: Adjust based on your security requirements

Set `TOFU_ENCRYPTION_KMS_KEY_ID` in your environment, or override `kms_key_id` in this unit when it needs a dedicated key.

## Integration

This namespace can be used by other units:

```hcl
# In another job unit
job "myapp" {
  namespace = "production"
  # ...
}
```
