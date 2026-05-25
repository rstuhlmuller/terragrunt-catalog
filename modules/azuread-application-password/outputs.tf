output "id" {
  description = "The Terraform ID of the application password"
  value       = azuread_application_password.this.id
}

output "key_id" {
  description = "The key ID of the application password"
  value       = azuread_application_password.this.key_id
}

output "display_name" {
  description = "The display name of the application password"
  value       = azuread_application_password.this.display_name
}

output "start_date" {
  description = "The password start date"
  value       = azuread_application_password.this.start_date
}

output "end_date" {
  description = "The password end date"
  value       = azuread_application_password.this.end_date
}

output "value" {
  description = "The generated password value"
  value       = azuread_application_password.this.value
  sensitive   = true
}
