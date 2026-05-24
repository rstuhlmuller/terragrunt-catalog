output "manifest" {
  description = "The desired Argo CD ApplicationSet manifest"
  value       = kubernetes_manifest.this.manifest
}

output "object" {
  description = "The ApplicationSet object returned by the Kubernetes API server"
  value       = kubernetes_manifest.this.object
}

output "name" {
  description = "The ApplicationSet name"
  value       = try(kubernetes_manifest.this.object.metadata.name, var.name)
}

output "namespace" {
  description = "The ApplicationSet namespace"
  value       = try(kubernetes_manifest.this.object.metadata.namespace, var.namespace)
}
