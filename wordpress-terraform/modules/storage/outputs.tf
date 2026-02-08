output "ssm_bucket_name" { value = aws_s3_bucket.ssm.bucket }
output "ssm_bucket_arn" { value = aws_s3_bucket.ssm.arn }

output "efs_id" { value = aws_efs_file_system.this.id }
output "efs_dns_name" { value = aws_efs_file_system.this.dns_name }
