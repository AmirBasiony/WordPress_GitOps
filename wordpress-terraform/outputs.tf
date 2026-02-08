output "vpc_id" { value = module.network.vpc_id }
output "vpc_cidr" { value = module.network.vpc_cidr }

output "public_subnet_ids" { value = module.network.public_subnet_ids }
output "private_subnet_ids" { value = module.network.private_subnet_ids }

output "efs_dns_name" { value = module.storage.efs_dns_name }
output "ssm_bucket" { value = module.storage.ssm_bucket_name }

output "web_instance_ids" { value = module.compute.web_instance_ids }
output "web_instance_private_ips" { value = module.compute.web_instance_private_ips }
output "mysql_instance_id" { value = module.compute.mysql_instance_id }
output "mysql_private_ip" { value = module.compute.mysql_private_ip }

output "alb_dns_name" { value = module.alb.alb_dns_name }

output "cloudflare_zone_id" { value = module.edge.cloudflare_zone_id }
output "fqdn" { value = module.edge.fqdn }

