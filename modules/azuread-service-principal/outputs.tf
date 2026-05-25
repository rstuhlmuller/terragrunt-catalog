output "id" {
  description = "The Terraform ID of the service principal"
  value       = azuread_service_principal.this.id
}

output "object_id" {
  description = "The object ID of the service principal"
  value       = azuread_service_principal.this.object_id
}

output "client_id" {
  description = "The client ID of the associated application"
  value       = azuread_service_principal.this.client_id
}

output "display_name" {
  description = "The display name of the associated application"
  value       = azuread_service_principal.this.display_name
}

output "application_tenant_id" {
  description = "Tenant ID where the associated application is registered"
  value       = azuread_service_principal.this.application_tenant_id
}

output "app_role_ids" {
  description = "Mapping of app role values to app role IDs"
  value       = azuread_service_principal.this.app_role_ids
}

output "oauth2_permission_scope_ids" {
  description = "Mapping of OAuth2 permission scope values to scope IDs"
  value       = azuread_service_principal.this.oauth2_permission_scope_ids
}

output "service_principal_names" {
  description = "Identifier URIs copied from the associated application"
  value       = azuread_service_principal.this.service_principal_names
}

output "saml_metadata_url" {
  description = "SAML metadata URL for federation"
  value       = azuread_service_principal.this.saml_metadata_url
}

output "type" {
  description = "Service principal type"
  value       = azuread_service_principal.this.type
}
