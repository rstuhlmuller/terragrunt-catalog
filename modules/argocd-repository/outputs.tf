output "id" {
  description = "Repository identifier"
  value       = argocd_repository.this.id
}

output "repo" {
  description = "Repository URL"
  value       = argocd_repository.this.repo
}

output "name" {
  description = "Repository display name"
  value       = argocd_repository.this.name
}

output "type" {
  description = "Repository type"
  value       = argocd_repository.this.type
}

output "project" {
  description = "Project-scoped repository name"
  value       = argocd_repository.this.project
}

output "connection_state_status" {
  description = "Current repository connection state"
  value       = argocd_repository.this.connection_state_status
}

output "inherited_creds" {
  description = "Whether credentials were inherited from a credential set"
  value       = argocd_repository.this.inherited_creds
}
