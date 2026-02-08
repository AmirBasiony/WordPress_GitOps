data "aws_acm_certificate" "app_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "cloudflare_zone" "this" {
  name = var.cloudflare_zone_name
}

resource "cloudflare_record" "subdomain_cname" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.subdomain_name
  type    = "CNAME"
  content = var.alb_dns_name

  proxied = var.proxied
  ttl     = var.ttl
}
