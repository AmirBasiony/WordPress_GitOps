variable "environment" {
  description = "dev | stage | prod"
  type        = string
}

variable "name_prefix" {
  description = "Base prefix for resources"
  type        = string
  default     = "amir-wp"
}

variable "owner" {
  description = "Owner tag"
  type        = string
  default     = "amir"
}

variable "tags" {
  description = "Extra tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  description = "List of AZs (must match subnets count)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "wp_ami" {
  type    = string
  default = "ami-04ac22cc531f2fd24"
}

variable "db_ami" {
  type    = string
  default = "ami-0c398cb65a93047f2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "user_data_path" {
  description = "Relative to root module (wordpress-terraform/)"
  type        = string
  default     = "scripts/install_ssm_agent.sh"
}

# ACM lookup
variable "domain_name" {
  type    = string
  default = "*.cloud-stacks.com"
}

# Cloudflare
variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_name" {
  type    = string
  default = "cloud-stacks.com"
}

variable "subdomain" {
  type    = string
  default = "amir"
}

# IAM role names (existing roles)
variable "app_role_name" {
  type    = string
  default = "ASG-Access-Role-to-S3-SSM"
}

variable "ssm_role_name" {
  type    = string
  default = "EC2-SSM-Role"
}

# S3 bucket naming controls
variable "ssm_bucket_name_override" {
  description = "Optional. If empty, module will generate name"
  type        = string
  default     = ""
}

# ALB health check defaults
variable "alb_healthcheck_path" {
  type    = string
  default = "/health"
}

variable "ansible_repo_path" {
  description = "Path to your wordpress-ansible directory (relative or absolute)"
  type        = string
  default     = "./../wordpress-ansible"
}

# ----------------------------
# Storage (EFS)
# ----------------------------
variable "enable_efs_backup" {
  description = "Enable EFS backup policy"
  type        = bool
  default     = true
}

# ----------------------------
# ALB
# ----------------------------
variable "alb_target_port" {
  description = "Target group port (traffic port for instances)"
  type        = number
  default     = 80
}

# ----------------------------
# Cloudflare
# ----------------------------
variable "cloudflare_proxied" {
  description = "Whether Cloudflare proxy is enabled for the DNS record"
  type        = bool
  default     = true
}

variable "cloudflare_ttl" {
  description = "Cloudflare DNS TTL. 1 means 'Auto'"
  type        = number
  default     = 1
}
