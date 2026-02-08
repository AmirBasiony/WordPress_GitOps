module "network" {
  source = "./modules/network"

  name_prefix = local.full_prefix
  owner       = var.owner
  tags        = local.common_tags

  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "storage" {
  source = "./modules/storage"

  name_prefix              = local.full_prefix
  owner                    = var.owner
  tags                     = local.common_tags
  aws_region               = var.aws_region
  private_subnet_ids       = module.network.private_subnet_ids
  efs_sg_id                = module.network.efs_sg_id
  enable_efs_backup        = var.enable_efs_backup
  ssm_bucket_name_override = var.ssm_bucket_name_override
}

module "iam_ssm" {
  source = "./modules/iam_ssm"

  name_prefix = local.full_prefix
  owner       = var.owner
  tags        = local.common_tags

  app_role_name          = var.app_role_name
  ssm_role_name          = var.ssm_role_name
  ansible_ssm_bucket_arn = module.storage.ssm_bucket_arn
}

module "compute" {
  source = "./modules/compute"

  name_prefix = local.full_prefix
  owner       = var.owner
  tags        = local.common_tags

  web_servers     = local.web_servers
  mysql_subnet_id = module.network.private_subnet_ids[0]

  wp_ami        = var.wp_ami
  db_ami        = var.db_ami
  instance_type = var.instance_type
  
  web_sg_id   = module.network.web_sg_id
  mysql_sg_id = module.network.mysql_sg_id

  nat_gateway_id = module.network.nat_gateway_id  # Pass the nat_gateway_id to compute module
  
  app_instance_profile_name   = module.iam_ssm.app_instance_profile_name
  mysql_instance_profile_name = module.iam_ssm.mysql_instance_profile_name

  associate_public_ip_address = var.associate_public_ip_address
  user_data_path              = var.user_data_path
}

data "aws_acm_certificate" "app_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

module "alb" {
  source = "./modules/alb"

  name_prefix = local.full_prefix
  owner       = var.owner
  tags        = local.common_tags

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.network.alb_sg_id

  certificate_arn = data.aws_acm_certificate.app_cert.arn

  target_port      = var.alb_target_port
  web_instance_ids = values(module.compute.web_instance_ids)

  healthcheck_path = var.alb_healthcheck_path
}

module "edge" {
  source = "./modules/edge"

  domain_name          = var.domain_name
  cloudflare_zone_name = var.cloudflare_zone_name
  subdomain_name       = local.full_subdomain

  alb_dns_name = module.alb.alb_dns_name

  proxied = var.cloudflare_proxied
  ttl     = var.cloudflare_ttl
}
