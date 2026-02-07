output "vpc_id" {
  value       = aws_vpc.AppVPC.id
  description = "The ID of the main application VPC"
}

output "vpc_cidr" {
  value       = aws_vpc.AppVPC.cidr_block
  description = "CIDR block of the main application VPC"
}
# output "aws_region" {
#   value       = var.aws_region
#   description = "AWS region used for the deployment"
# }

output "public_subnet1_id" {
  value       = aws_subnet.public_subnet_1.id
  description = "ID of public subnet 1"
}

output "public_subnet2_id" {
  value       = aws_subnet.public_subnet_2.id
  description = "ID of public subnet 2"
}

output "private_subnet1_id" {
  value       = aws_subnet.private_subnet_1.id
  description = "ID of private subnet 1"
}

output "private_subnet2_id" {
  value       = aws_subnet.private_subnet_2.id
  description = "ID of private subnet 2"
}

output "alb_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}

# output "alb_arn" {
#   value       = aws_lb.web_alb.arn
#   description = "ARN of the Application Load Balancer"
# }

# Web instances created via for_each (locals.web_servers)
output "web_instance_ids" {
  value       = { for k, inst in aws_instance.web : k => inst.id }
  description = "Map of web instance IDs keyed by local.web_servers keys"
}

output "web_instance_private_ips" {
  value       = { for k, inst in aws_instance.web : k => inst.private_ip }
  description = "Map of web instance private IPs keyed by local.web_servers keys"
}

# MySQL instance (single)
output "mysql_instance_id" {
  value       = aws_instance.mysql.id
  description = "Instance ID of the MySQL EC2 server"
}

output "mysql_private_ip" {
  value       = aws_instance.mysql.private_ip
  description = "Private IP of the MySQL EC2 server"
}

# output "nat_gateway_id" {
#   value       = aws_nat_gateway.nat.id
#   description = "The ID of the NAT Gateway"
# }

# output "nat_eip" {
#   value       = aws_eip.nat_eip.public_ip
#   description = "The Elastic IP address of the NAT Gateway"
# }

# # Instance profiles you actually created in IAM
# output "app_instance_profile_name" {
#   value       = aws_iam_instance_profile.app_profile.name
#   description = "IAM instance profile name for app/web instances"
# }

# output "mysql_instance_profile_name" {
#   value       = aws_iam_instance_profile.mysql_profile.name
#   description = "IAM instance profile name for MySQL instance"
# }

# output "ansible_ssm_bucket_name" {
#   value       = aws_s3_bucket.ansible_ssm_bucket.bucket
#   description = "Name of the S3 bucket used for Ansible SSM"
# }

# output "efs_id" {
#   value       = aws_efs_file_system.app_efs.id
#   description = "EFS filesystem ID"
# }

output "efs_dns_name" {
  value       = aws_efs_file_system.app_efs.dns_name
  description = "EFS DNS name"
}
