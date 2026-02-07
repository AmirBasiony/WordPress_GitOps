terraform {
  backend "s3" {
    bucket       = "amir-app"
    key          = "infra/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = " ~> 6.0"
    # }
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "~> 4.0"
    # }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.6"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
