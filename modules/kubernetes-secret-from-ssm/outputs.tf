output "id" {
  description = "The Secret ID"
  value       = kubernetes_secret_v1.this.id
}

output "name" {
  description = "Name of the Kubernetes Secret"
  value       = kubernetes_secret_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the Kubernetes Secret"
  value       = kubernetes_secret_v1.this.metadata[0].namespace
}

output "keys" {
  description = "Kubernetes Secret keys managed by this module"
  value       = keys(var.data_ssm_parameter_names)
}

output "metadata" {
  description = "Secret metadata"
  value       = kubernetes_secret_v1.this.metadata
}
