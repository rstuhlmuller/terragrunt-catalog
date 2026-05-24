# Nomad Nginx Job Unit

This unit deploys an Nginx web server as a Nomad job using the `nomad-job` module.

## Description

Deploys a simple Nginx web server with:
- 3 replicas for high availability
- HTTP service on port 8080
- Health checks configured
- Docker driver
- Service registration in Consul

## Prerequisites

- Nomad cluster configured and accessible
- Docker driver enabled on Nomad clients
- AWS KMS key created for state encryption
- Consul for service discovery (optional but recommended)

## Usage

```bash
# Initialize and apply
terragrunt init
terragrunt plan
terragrunt apply

# Check job status
nomad job status nginx-web

# View allocations
nomad job allocs nginx-web
```

## Configuration

Set `TOFU_ENCRYPTION_KMS_KEY_ID` in your environment, or override `kms_key_id` in this unit when it needs a dedicated key.

## Outputs

This unit will output:
- Job ID
- Job status
- Allocation IDs
- Task groups
- Datacenters
