output "id" {
  description = "Project identifier"
  value       = argocd_project.this.id
}

output "name" {
  description = "Project name"
  value       = argocd_project.this.metadata[0].name
}

output "namespace" {
  description = "Project namespace"
  value       = argocd_project.this.metadata[0].namespace
}

output "metadata" {
  description = "Project metadata"
  value       = argocd_project.this.metadata
}

output "spec" {
  description = "Project spec"
  value       = argocd_project.this.spec
}
