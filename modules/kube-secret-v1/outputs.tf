output "id" {
  description = "The Secret ID"
  value       = kubernetes_secret_v1.this.id
}

output "name" {
  description = "The Secret name"
  value       = kubernetes_secret_v1.this.metadata[0].name
}

output "namespace" {
  description = "The Secret namespace"
  value       = kubernetes_secret_v1.this.metadata[0].namespace
}

output "type" {
  description = "The Secret type"
  value       = kubernetes_secret_v1.this.type
}

output "metadata" {
  description = "Secret metadata"
  value       = kubernetes_secret_v1.this.metadata
}
