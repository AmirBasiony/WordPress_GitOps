output "acm_certificate_arn" {
  value       = data.aws_acm_certificate.app_cert.arn
  description = "ARN of the ACM certificate"
}

output "cloudflare_zone_id" {
  value       = data.cloudflare_zone.this.id
  description = "Cloudflare zone ID"
}

output "fqdn" {
  value       = cloudflare_record.subdomain_cname.hostname
  description = "Fully qualified domain name"
}

