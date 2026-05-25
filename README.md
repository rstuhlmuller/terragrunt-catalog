# Terragrunt Catalog

A Terragrunt configuration catalog for managing Nomad, Helm, Kubernetes, Argo CD, AWS secret bootstrap, and AzureAD application resources with OpenTofu state encryption.

## Overview

This repository contains reusable Terraform/OpenTofu modules and example Terragrunt units. Modules are intentionally small and resource-focused so a Terragrunt unit can own one clear piece of infrastructure.

## Features

- **OpenTofu State Encryption**: Modules include AWS KMS encryption for state and plan files
- **Nomad Resources**: Jobs, namespaces, variables, and CSI volumes
- **Helm Resources**: Complete `helm_release` lifecycle and values controls
- **Kubernetes Resources**: Typed v1 bootstrap resources plus a generic manifest module for CRDs and versioned APIs
- **Argo CD Resources**: Applications, Application CRD manifests, ApplicationSet CRD manifests, projects, and repositories
- **AWS Secret Bootstrap**: SSM SecureString parameters and Kubernetes Secrets sourced from SSM
- **AzureAD Applications**: Application registrations, application passwords, and service principals
- **Terragrunt Examples**: Units for common Nomad, Helm, Kubernetes, and Argo CD workflows

## Repository Structure

```text
.
├── modules/
│   ├── argocd-application/
│   ├── argocd-application-manifest/
│   ├── argocd-application-set-manifest/
│   ├── argocd-project/
│   ├── argocd-repository/
│   ├── aws-ssm-parameters/
│   ├── azuread-application/
│   ├── azuread-application-password/
│   ├── azuread-service-principal/
│   ├── helm-release/
│   ├── kube-config-map-v1/
│   ├── kubernetes-secret-from-ssm/
│   ├── kube-manifest/
│   ├── kube-namespace-v1/
│   ├── kube-secret-v1/
│   └── nomad-*/
├── units/
│   ├── argocd-guestbook-app/
│   ├── helm-argocd-install/
│   ├── kube-platform-namespace/
│   └── nomad-*/
└── terragrunt.hcl
```

## Modules

### Helm

- [helm-release](modules/helm-release/README.md): manages `helm_release` with release lifecycle, values, sensitive values, write-only values, and post-render support.

### Kubernetes

- [kube-manifest](modules/kube-manifest/README.md): manages any Kubernetes resource through `kubernetes_manifest`.
- [kube-namespace-v1](modules/kube-namespace-v1/README.md): manages `kubernetes_namespace_v1`.
- [kube-config-map-v1](modules/kube-config-map-v1/README.md): manages `kubernetes_config_map_v1`.
- [kube-secret-v1](modules/kube-secret-v1/README.md): manages `kubernetes_secret_v1`, including provider write-only secret inputs.
- [kubernetes-secret-from-ssm](modules/kubernetes-secret-from-ssm/README.md): creates `kubernetes_secret_v1` data from encrypted AWS SSM parameters.

### AWS

- [aws-ssm-parameters](modules/aws-ssm-parameters/README.md): manages SSM SecureString parameters, optional KMS key creation, and optional IAM reader access.

### Argo CD

- [argocd-application](modules/argocd-application/README.md): typed `argocd_application` module with Terragrunt-friendly controls for metadata, destinations, sources, Helm, Kustomize, directory, plugin, sync policy, retry, diffing, and info.
- [argocd-application-manifest](modules/argocd-application-manifest/README.md): raw Application CRD manifest module for exact API/version control.
- [argocd-application-set-manifest](modules/argocd-application-set-manifest/README.md): raw ApplicationSet CRD manifest module for complete generator/template/strategy control.
- [argocd-project](modules/argocd-project/README.md): manages project source, destination, resource, orphaned resource, role, and sync-window controls.
- [argocd-repository](modules/argocd-repository/README.md): manages Git, Helm, and OCI repositories with common auth modes.

### AzureAD

- [azuread-application](modules/azuread-application/README.md): manages AzureAD application registrations, redirect URIs, app roles, required resource access, optional claims, and optional inline passwords.
- [azuread-application-password](modules/azuread-application-password/README.md): manages generated client secrets for AzureAD applications.
- [azuread-service-principal](modules/azuread-service-principal/README.md): manages service principals linked to AzureAD applications.

### Nomad

- [nomad-job](modules/nomad-job/README.md): manages Nomad jobs from HCL or JSON jobspecs.
- [nomad-namespace](modules/nomad-namespace/README.md): manages Nomad namespaces and capability controls.
- [nomad-variable](modules/nomad-variable/README.md): manages Nomad variables.
- [nomad-csi-volume](modules/nomad-csi-volume/README.md): creates CSI volumes.
- [nomad-csi-volume-registration](modules/nomad-csi-volume-registration/README.md): registers existing CSI volumes.

## Units

- [helm-argocd-install](units/helm-argocd-install/README.md): installs Argo CD with Helm.
- [kube-platform-namespace](units/kube-platform-namespace/README.md): creates a platform namespace.
- [argocd-guestbook-app](units/argocd-guestbook-app/README.md): creates an Argo CD guestbook application.
- Existing Nomad units show namespace, variable, batch, and service job patterns.

## Prerequisites

- [OpenTofu](https://opentofu.org/) or Terraform with compatible provider support
- [Terragrunt](https://terragrunt.gruntwork.io/) >= 0.45.0
- AWS credentials with access to the KMS key used for state encryption
- Optional, based on the units you run:
  - Nomad cluster and ACL token
  - Kubernetes cluster and kubeconfig
  - Argo CD installation and Argo CD provider credentials
  - Azure tenant credentials for AzureAD application modules

## Provider Configuration

The root `terragrunt.hcl` generates provider blocks for AWS, Nomad, Kubernetes, Helm, Argo CD, and AzureAD.

```bash
export ENVIRONMENT="production"
export AWS_REGION="us-east-1"
export AWS_PROFILE="default"

export TOFU_ENCRYPTION_KMS_KEY_ID="arn:aws:kms:us-east-1:123456789012:key/example"
export TOFU_ENCRYPTION_KMS_REGION="us-east-1"
export TOFU_ENCRYPTION_KMS_KEY_SPEC="AES_256"

export NOMAD_ADDR="https://nomad.example.com:4646"
export NOMAD_TOKEN="your-nomad-acl-token" # checkov:skip=CKV_SECRET_6: Not a real secret

export KUBE_CONFIG_PATH="$HOME/.kube/config"
export KUBE_CTX="production"

export ARGOCD_SERVER="argocd.example.com:443"
export ARGOCD_AUTH_TOKEN="your-argocd-token" # checkov:skip=CKV_SECRET_6: Not a real secret

export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="example-client-secret" # checkov:skip=CKV_SECRET_6: Not a real secret
```

The Argo CD provider block is intentionally empty so the provider can use its supported `ARGOCD_*` environment variables, local config, port-forward, or core mode without forcing one auth model into every unit.

The AzureAD provider block is also intentionally empty so the provider can use Azure CLI, workload identity, or `ARM_*` environment variables depending on the runner.

## Quick Start

### Install Argo CD With Helm

```bash
cd units/helm-argocd-install
terragrunt init
terragrunt plan
terragrunt apply
```

### Create A Kubernetes Namespace

```bash
cd ../kube-platform-namespace
terragrunt init
terragrunt apply
```

### Create An Argo CD Application

```bash
cd ../argocd-guestbook-app
terragrunt init
terragrunt plan
terragrunt apply
```

## Argo CD Application Control

Use `argocd-application` when the typed Argo CD provider schema is enough and you want clearer Terraform plans. Use `argocd-application-manifest` when you need exact CRD control over any field supported by the installed Argo CD version. This gives Terragrunt a structured path and a raw-manifest path for the same resource.

For ApplicationSets, the catalog uses `argocd-application-set-manifest` because the ApplicationSet API is broad and changes quickly. Passing the complete `spec` through Terragrunt avoids losing access to new generator or strategy fields.

## OpenTofu Encryption

All modules include OpenTofu encryption configuration using AWS KMS:

```hcl
terraform {
  encryption {
    key_provider "aws_kms" "main" {
      kms_key_id = var.kms_key_id
      key_spec   = var.kms_key_spec
      region     = var.kms_region
    }

    method "aes_gcm" "main" {
      keys = key_provider.aws_kms.main
    }

    state {
      method   = method.aes_gcm.main
      enforced = true
    }

    plan {
      method   = method.aes_gcm.main
      enforced = true
    }
  }
}
```

The root Terragrunt configuration supplies these encryption inputs to every unit:

- `kms_key_id`: from `TOFU_ENCRYPTION_KMS_KEY_ID`
- `kms_region`: from `TOFU_ENCRYPTION_KMS_REGION`, defaulting to `AWS_REGION`
- `kms_key_spec`: from `TOFU_ENCRYPTION_KMS_KEY_SPEC`, defaulting to `AES_256`

Individual units can still override any of these inputs when they need a different key, region, or key spec.

For advanced migrations, fallbacks, or non-AWS key providers, use OpenTofu's `TF_ENCRYPTION` environment configuration to merge or override the code-based configuration.

## Security Considerations

- State files can contain rendered Helm manifests, Kubernetes Secret values, SSM parameter placeholders, Argo CD repository credentials, AzureAD application passwords, and Nomad variables. Keep KMS encryption enabled.
- Store remote state in an encrypted S3 bucket with DynamoDB locking and restrictive IAM policies.
- Prefer provider write-only inputs for Helm values and Kubernetes Secret values when the provider supports them.
- Keep Argo CD repository credentials project-scoped where possible.
- Install CRDs in a separate step before planning resources that depend on them.

## Troubleshooting

### Kubernetes Manifest Planning Fails

`kubernetes_manifest` needs API server access at plan time and validates resource schemas. Make sure the cluster is reachable and CRDs are already installed.

### Argo CD Provider Authentication Fails

Verify the same auth path works with the Argo CD CLI first, then mirror it through `ARGOCD_*` environment variables or local Argo CD config.

### KMS Access Denied

```bash
aws kms describe-key --key-id your-key-id
```

The identity running Terragrunt needs `kms:Encrypt`, `kms:Decrypt`, `kms:DescribeKey`, and `kms:GenerateDataKey` on the configured key.

## Resources

- [Nomad Documentation](https://www.nomadproject.io/docs)
- [Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
- [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Argo CD Provider](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs)
- [AzureAD Provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)
- [OpenTofu Encryption](https://opentofu.org/docs/language/state/encryption/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
