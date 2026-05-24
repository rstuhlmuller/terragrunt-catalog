output "id" {
  description = "The ConfigMap ID"
  value       = kubernetes_config_map_v1.this.id
}

output "name" {
  description = "The ConfigMap name"
  value       = kubernetes_config_map_v1.this.metadata[0].name
}

output "namespace" {
  description = "The ConfigMap namespace"
  value       = kubernetes_config_map_v1.this.metadata[0].namespace
}

output "metadata" {
  description = "ConfigMap metadata"
  value       = kubernetes_config_map_v1.this.metadata
}
