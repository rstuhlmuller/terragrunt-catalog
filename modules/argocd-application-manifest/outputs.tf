output "manifest" {
  description = "The desired Argo CD Application manifest"
  value       = kubernetes_manifest.this.manifest
}

output "object" {
  description = "The Application object returned by the Kubernetes API server"
  value       = kubernetes_manifest.this.object
}

output "name" {
  description = "The Application name"
  value       = try(kubernetes_manifest.this.object.metadata.name, var.name)
}

output "namespace" {
  description = "The Application namespace"
  value       = try(kubernetes_manifest.this.object.metadata.namespace, var.namespace)
}

output "sync_status" {
  description = "The Application sync status, when returned by the API server"
  value       = try(kubernetes_manifest.this.object.status.sync.status, null)
}

output "health_status" {
  description = "The Application health status, when returned by the API server"
  value       = try(kubernetes_manifest.this.object.status.health.status, null)
}
