output "app_instance_profile_name" {
  value       = aws_iam_instance_profile.app_profile.name
  description = "IAM instance profile name for app/web instances"
}

output "mysql_instance_profile_name" {
  value       = aws_iam_instance_profile.mysql_profile.name
  description = "IAM instance profile name for MySQL instance"
}

