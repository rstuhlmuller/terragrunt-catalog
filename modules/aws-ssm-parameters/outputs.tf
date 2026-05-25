output "parameter_names" {
  description = "SSM Parameter Store names managed by this module"
  value       = keys(aws_ssm_parameter.this)
}

output "parameter_arns" {
  description = "SSM Parameter Store ARNs managed by this module"
  value       = { for name, parameter in aws_ssm_parameter.this : name => parameter.arn }
}

output "parameter_kms_key_id" {
  description = "KMS key ID or alias used for SSM SecureString parameters"
  value       = local.effective_parameter_kms_key_id
}

output "parameter_kms_key_arn" {
  description = "KMS key ARN used for SSM SecureString parameters"
  value       = local.effective_parameter_kms_key_arn
}

output "parameter_reader_iam_group_name" {
  description = "IAM group name granted read access to managed parameters"
  value       = local.create_parameter_reader_iam_group ? aws_iam_group.parameter_readers[0].name : null
}
