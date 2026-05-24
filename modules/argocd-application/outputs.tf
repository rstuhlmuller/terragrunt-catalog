output "id" {
  description = "The Argo CD application ID"
  value       = argocd_application.this.id
}

output "name" {
  description = "The Argo CD application name"
  value       = argocd_application.this.metadata[0].name
}

output "namespace" {
  description = "The Argo CD application namespace"
  value       = argocd_application.this.metadata[0].namespace
}

output "project" {
  description = "The Argo CD project"
  value       = argocd_application.this.spec[0].project
}

output "metadata" {
  description = "Application metadata"
  value       = argocd_application.this.metadata
}

output "spec" {
  description = "Application spec"
  value       = argocd_application.this.spec
}

output "status" {
  description = "Application status"
  value       = argocd_application.this.status
}
