locals {
  full_prefix = "${var.name_prefix}-${var.environment}"
  common_tags = merge(
    {
      Project     = "wordpress"
      Environment = var.environment
      Owner       = var.owner
    },
    var.tags
  )

  full_subdomain = var.environment == "prod" ? var.subdomain : "${var.subdomain}-${var.environment}"

  # Default: 2 web servers (you can change per env)
  web_servers = {
    web1 = {
      name      = "${local.full_prefix}-web1"
      subnet_id = module.network.private_subnet_ids[0]
    }
    web2 = {
      name      = "${local.full_prefix}-web2"
      subnet_id = module.network.private_subnet_ids[1]
    }
  }
}
