output "web_instance_ids" {
  value       = { for k, inst in aws_instance.web : k => inst.id }
  description = "Map of web instance IDs"
}

output "web_instance_private_ips" {
  value       = { for k, inst in aws_instance.web : k => inst.private_ip }
  description = "Map of web instance private IPs"
}

output "mysql_instance_id" {
  value       = aws_instance.mysql.id
  description = "Instance ID of the MySQL EC2 server"
}

output "mysql_private_ip" {
  value       = aws_instance.mysql.private_ip
  description = "Private IP of the MySQL EC2 server"
}
