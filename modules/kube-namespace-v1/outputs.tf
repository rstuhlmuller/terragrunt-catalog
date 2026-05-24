output "id" {
  description = "The namespace ID"
  value       = kubernetes_namespace_v1.this.id
}

output "name" {
  description = "The namespace name"
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "metadata" {
  description = "Namespace metadata"
  value       = kubernetes_namespace_v1.this.metadata
}
