output "manifest" {
  description = "The desired Kubernetes manifest"
  value       = kubernetes_manifest.this.manifest
}

output "object" {
  description = "The object returned by the Kubernetes API server"
  value       = kubernetes_manifest.this.object
}

output "api_version" {
  description = "The object API version"
  value       = try(kubernetes_manifest.this.object.apiVersion, kubernetes_manifest.this.manifest.apiVersion)
}

output "kind" {
  description = "The object kind"
  value       = try(kubernetes_manifest.this.object.kind, kubernetes_manifest.this.manifest.kind)
}

output "name" {
  description = "The object name"
  value       = try(kubernetes_manifest.this.object.metadata.name, kubernetes_manifest.this.manifest.metadata.name)
}

output "namespace" {
  description = "The object namespace, when namespaced"
  value       = try(kubernetes_manifest.this.object.metadata.namespace, kubernetes_manifest.this.manifest.metadata.namespace, null)
}
