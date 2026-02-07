resource "cloudflare_record" "amir_cname" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.subdomain
  type    = "CNAME"
  content   = aws_lb.web_alb.dns_name   # <-- ALB DNS
  proxied = true
  ttl     = 1 # Auto
}

data "cloudflare_zone" "this" {
  name = "cloud-stacks.com"
}

output "cloudflare_zone_id" {
  value = data.cloudflare_zone.this.id
}
