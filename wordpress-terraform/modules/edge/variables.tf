variable "domain_name" {
  description = "Domain name to lookup ACM certificate (e.g. *.cloud-stacks.com)"
  type        = string
}

variable "cloudflare_zone_name" {
  description = "Cloudflare zone name (e.g. cloud-stacks.com)"
  type        = string
  default     = "cloud-stacks.com"
}

variable "subdomain_name" {
  description = "Full subdomain (e.g. amir-dev)"
  type        = string
  default     = "amir-dev"
}

variable "alb_dns_name" {
  description = "ALB DNS name"
  type        = string
}

variable "proxied" {
  description = "Whether Cloudflare proxies the record"
  type        = bool
  default     = true
}

variable "ttl" {
  description = "Cloudflare TTL (1 = Auto)"
  type        = number
  default     = 1
}
